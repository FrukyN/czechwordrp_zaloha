let cart = [];
let total = 0;
let currency = "Kč";
let currentItems = []; // Pomocná proměnná pro uložení všech položek pro filtrování

// 1. HLAVNÍ NASLOUCHÁNÍ NA LUA
window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === "display") {
        // Otevření pokladny pro prodavače
    const themeColor = data.color || "#3d85ff"; // Default modrá
    document.documentElement.style.setProperty('--accent-blue', themeColor);
    document.querySelector('.tablet-frame').style.boxShadow = `0 50px 100px ${themeColor}33`; // Jemná záře
        document.getElementById('receipt-container').style.display = 'none'; // Schovat účtenku
        document.getElementById('app-container').style.display = 'flex';
        document.getElementById('shop-name').innerText = data.label;
        currency = data.currency || "Kč";
        setupItems(data.items);
    } 
    else if (data.action === "showReceipt") {
        // Zobrazení účtenky pro zákazníka
        showReceipt(data);
    }
});

// 2. GENEROVÁNÍ POLOŽEK V POKLADNĚ (Opraveno pro kategorie)
function setupItems(items) {
    currentItems = items; 
    const list = document.getElementById('items-list');
    list.innerHTML = '';
    
    if (!items || items.length === 0) return;

    // Zjistíme unikátní kategorie (vyloučíme prázdné)
    const categories = [...new Set(items.map(item => item.category).filter(cat => cat))];

    // LOGIKA: Pokud je víc než 1 kategorie, ukaž menu kategorií. Jinak rovnou položky.
    if (categories.length > 1) {
        renderCategoryButtons(categories);
    } else {
        renderActualItems(items);
    }
}

// POMOCNÁ FUNKCE: Vykreslení tlačítek kategorií
function renderCategoryButtons(categories) {
    const list = document.getElementById('items-list');
    list.innerHTML = '';

    categories.forEach(cat => {
        const div = document.createElement('div');
        div.className = 'item-card'; 
        div.style.justifyContent = 'center';
        div.style.borderLeft = '4px solid #3498db';
        div.innerHTML = `
            <div class="emoji">📁</div>
            <div style="font-weight: 800; text-transform: uppercase;">${cat}</div>
        `;
        div.onclick = () => {
            const filtered = currentItems.filter(i => i.category === cat);
            renderActualItems(filtered, true);
        };
        list.appendChild(div);
    });
}

// POMOCNÁ FUNKCE: Vykreslení samotných produktů (včetně tlačítka zpět)
function renderActualItems(items, showBack = false) {
    const list = document.getElementById('items-list');
    list.innerHTML = '';

    if (showBack) {
        const backDiv = document.createElement('div');
        backDiv.className = 'item-card';
        backDiv.style.background = 'rgba(255,255,255,0.05)';
        backDiv.innerHTML = `
            <div class="emoji">⬅️</div>
            <div style="font-weight: 600;">Zpět</div>
        `;
        backDiv.onclick = () => setupItems(currentItems);
        list.appendChild(backDiv);
    }

    items.forEach(item => {
        const div = document.createElement('div');
        div.className = 'item-card';
        div.innerHTML = `
            <div class="emoji">${item.icon || '📦'}</div>
            <div style="font-weight: 600;">${item.label}</div>
            <div style="font-size: 0.8rem; color: #888;">${item.price} ${currency}</div>
        `;
        div.onclick = () => {
            cart.push(item);
            renderCart();
        };
        list.appendChild(div);
    });
}

// 3. VYKRESLENÍ KOŠÍKU
function renderCart() {
    const cartDiv = document.getElementById('cart-items');
    cartDiv.innerHTML = '';
    total = 0;
    
    cart.forEach((item) => {
        total += item.price;
        const div = document.createElement('div');
        div.className = 'cart-item';
        div.style = "display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid rgba(255,255,255,0.05); color:white;";
        div.innerHTML = `<span>${item.label}</span><span style="font-weight:bold;">${item.price} ${currency}</span>`;
        cartDiv.appendChild(div);
    });
    
    document.getElementById('total-price').innerText = `${total} ${currency}`;
}

// 4. FUNKCE MAZÁNÍ
function clearCart() {
    cart = [];
    renderCart();
    document.getElementById('target-id').value = '';
}

// 5. PLATBA
function pay(method) {
    // Načtení lokálního souboru (mnohem rychlejší a spolehlivější)
    let audio = new Audio('sounds/pay.mp3');
    audio.volume = 0.9;
    audio.play().catch(e => console.log("Místní zvuk selhal, pravděpodobně chybí v manifestu."));
    
    const targetId = document.getElementById('target-id').value;
    
    if (total === 0 || !targetId || targetId <= 0) return;

    fetch(`https://${GetParentResourceName()}/confirmPayment`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({
            items: cart,
            totalAmount: total,
            method: method,
            targetId: parseInt(targetId)
        })
    }).then(() => close());
}

// 6. ÚČTENKA (Logika pro zákazníka)
function showReceipt(data) {
    document.getElementById('app-container').style.display = 'none';
    document.getElementById('receipt-container').style.display = 'flex';
    document.getElementById('receipt-shop').innerText = data.shop;
    document.getElementById('receipt-total').innerText = `${data.total} ${data.currency}`;
    document.getElementById('receipt-date').innerText = new Date().toLocaleString();

    const list = document.getElementById('receipt-items-list');
    list.innerHTML = '';
    data.items.forEach(item => {
        const div = document.createElement('div');
        div.className = 'receipt-row';
        div.style = "display:flex; justify-content:space-between; margin-bottom:5px;";
        div.innerHTML = `<span>${item.label}</span><span>${item.price} ${data.currency}</span>`;
        list.appendChild(div);
    });
}

function closeReceipt() {
    document.getElementById('receipt-container').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeReceipt`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// 7. ZAVŘENÍ POKLADNY
function close() {
    document.getElementById('app-container').style.display = 'none';
    clearCart();
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

document.getElementById('close-btn').onclick = close;