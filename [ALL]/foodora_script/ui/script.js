let cart = [];
let currentShopId = null;
let allOrders = {};
let myJob = null;

// DEFINICE PRODUKTŮ
const ShopMenus = {
    ['pizza']: [
        { name: 'Pizza Margherita', price: 2600, icon: '🍕' },
        { name: 'Pizza Marinara', price: 2400, icon: '🍕' },
        { name: 'Pizza Quattro Formaggi', price: 3000, icon: '🍕' },
        { name: 'Pizza Capricciosa', price: 2800, icon: '🍕' },
        { name: 'Pizza Quattro Stagioni', price: 2900, icon: '🍕' },
        { name: 'Pizza Diavola', price: 2200, icon: '🍕' },
        { name: 'Kousek Margherity', price: 1200, icon: '🍕' },
        { name: 'Kousek Marinary', price: 1100, icon: '🍕' },
        { name: 'Kousek Quattro Formaggi', price: 1200, icon: '🍕' },
        { name: 'Kousek Capricciosy', price: 1150, icon: '🍕' },
        { name: 'Kousek Quattro Stagioni', price: 1500, icon: '🍕' },
        { name: 'Kousek Diavoly', price: 1100, icon: '🍕' },
    ],
    ['bahama']: [
        { name: 'Cheese Burger', price: 180, icon: '🍔' },
        { name: 'Hranolky', price: 60, icon: '🍟' }
    ]
};

// HLAVNÍ POSLUCHAČ ZPRÁV Z LUA
window.addEventListener('message', (event) => {
    const data = event.data;

    // 1. OTEVŘENÍ ZÁKAZNICKÉHO MENU
    if (data.action === "openCustomer") {
        document.body.style.display = "flex";
        document.getElementById('customer-view').style.display = "flex";
        document.getElementById('staff-view').style.display = "none";
        
        if (data.orders) allOrders = data.orders;
        
        renderShops(data.shops);
        showSubPage('shops'); 
        updateTracking(data.myOrder);
    }

    // 2. OTEVŘENÍ PORTÁLU PRO ZAMĚSTNANCE
    if (data.action === "openStaff") {
        document.body.style.display = "flex";
        document.getElementById('customer-view').style.display = "none";
        document.getElementById('staff-view').style.display = "block";
        
        myJob = data.job;
        allOrders = data.orders || {}; 
        renderStaffOrders(allOrders);
    }

    // 3. SYNCHRONIZACE DAT
    if (data.action === "syncOrders" || data.action === "refreshTracking") {
        allOrders = data.orders || allOrders; 
        
        // Aktualizace sledování pro zákazníka
        updateTracking(data.myOrder);
        
        // Aktualizace seznamu pro zaměstnance
        if (document.getElementById('staff-view').style.display === "block") {
            renderStaffOrders(allOrders);
        }
    }

    // 4. ZVUKOVÉ UPOZORNĚNÍ
    if (data.action === "playSound") {
        const audio = document.getElementById('alert-sound');
        if (audio) {
            audio.currentTime = 0;
            audio.play().catch(e => console.log("Audio fail:", e));
        }
    }
});

// --- FUNKCE PRO ZÁKAZNÍKA ---

function renderShops(shops) {
    const container = document.getElementById('shops-list');
    if (!container) return;
    container.innerHTML = "";

    let anyOnline = false;
    for (const [id, shop] of Object.entries(shops)) {
        if (shop.online) {
            anyOnline = true;
            const card = document.createElement('div');
            card.className = "card";
            card.innerHTML = `<span>${shop.label}</span> <span class="online">PŘIJÍMÁ OBJEDNÁVKY</span>`;
            card.onclick = () => openMenu(id, shop.label);
            container.appendChild(card);
        }
    }

    // Pokud není žádná restaurace online, vypíšeme zprávu
    if (!anyOnline) {
        container.innerHTML = `
            <div style="text-align:center; padding:40px; color:#555; width:100%;">
                <div style="font-size:50px;">🚫</div>
                <h2 style="margin:10px 0;">Všechny restaurace jsou uzavřeny</h2>
                <p>Momentálně není v práci žádný kuchař. Zkuste to prosím později.</p>
            </div>`;
    }
}

function openMenu(id, label) {
    currentShopId = id;
    document.getElementById('menu-title').innerText = "Menu: " + label;
    const container = document.getElementById('menu-list');
    container.innerHTML = "";

    const items = ShopMenus[id] || [];
    items.forEach(item => {
        const div = document.createElement('div');
        div.className = "card";
        div.innerHTML = `<div>${item.icon} ${item.name}</div> <b>${item.price}$</b>`;
        div.onclick = () => addToCart(item.name, item.price);
        container.appendChild(div);
    });
    showSubPage('menu');
}

function addToCart(name, price) {
    if (cart.length >= 5) return showInternalNotify("Košík je plný!");
    cart.push({name, price});
    renderCart();
}

function renderCart() {
    const container = document.getElementById('items-in-cart');
    container.innerHTML = "";
    let total = 0;
    cart.forEach((item) => {
        total += item.price;
        container.innerHTML += `<div class="card">${item.name} <span>${item.price}$</span></div>`;
    });
    document.getElementById('total-price').innerText = total;
}

function sendOrder() {
    if (cart.length === 0) return showInternalNotify("Košík je prázdný!");
    let total = parseInt(document.getElementById('total-price').innerText);
    
    fetch(`https://${GetParentResourceName()}/placeOrder`, {
        method: 'POST',
        body: JSON.stringify({shopId: currentShopId, cart: cart, total: total})
    });
    cart = [];
    renderCart();
    closeUI();
}

// --- FUNKCE PRO SLEDOVÁNÍ (TRACKING) ---

function updateTracking(myOrder) {
    const box = document.getElementById('my-order-container') || document.getElementById('order-status-text');
    if (!box) return;

    if (!myOrder) {
        box.innerHTML = `
            <div style="background: white; padding: 20px; border-radius: 15px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h3 style="color: #e91e63; margin: 0;">Žádná aktivní objednávka</h3>
            </div>`;
        return;
    }

    const statuses = {
        'waiting': {t: 'Čeká se na potvrzení', i: '⏳', c: '#ffa500'},
        'accepted': {t: 'Vaříme jídlo', i: '🍳', c: '#3498db'},
        'ready': {t: 'Zabaleno a připraveno', i: '📦', c: '#2ecc71'},
        'shipping': {t: 'Kurýr jede k vám', i: '🛵', c: '#9b59b6'},
        'delivered': {t: 'Doručeno', i: '✅', c: '#2ecc71'}
    };
    const s = statuses[myOrder.status] || {t: myOrder.status, i: '❓', c: '#888'};

    box.innerHTML = `
        <div style="background: white; padding: 25px; border-radius: 15px; text-align: center; border-left: 6px solid ${s.c}; box-shadow: 0 4px 20px rgba(0,0,0,0.1);">
            <div style="font-size: 50px; margin-bottom: 10px;">${s.i}</div>
            <h3 style="margin: 0; color: #333; font-size: 22px;">Objednávka #${myOrder.id}</h3>
            <p style="color: ${s.c}; font-weight: bold; font-size: 18px; margin-top: 10px; text-transform: uppercase;">${s.t}</p>
        </div>`;
}

// --- FUNKCE PRO ZAMĚSTNANCE ---

// OPRAVENÝ PORTÁL PRO ZAMĚSTNANCE (Bílé texty na tmavé kartě)
function renderStaffOrders(orders) {
    const container = document.getElementById('staff-orders');
    if (!container) return;
    container.innerHTML = "";

    const ordersArray = Object.values(orders);
    if (ordersArray.length === 0) {
        container.innerHTML = '<p style="text-align:center; color:#888; width:100%; padding:20px;">Žádné aktivní objednávky</p>';
        return;
    }

    ordersArray.forEach(order => {
        if (myJob && order.shopId.toLowerCase() !== myJob.name.toLowerCase()) return;

        let items = order.items.map(i => `<li style="margin-bottom:5px;">${i.count || 1}x ${i.label || i.name}</li>`).join('');
        
        let actionBtns = "";
        if (order.status === 'waiting') {
            actionBtns = `
                <button onclick="updateStatus('${order.id}', 'accepted')" style="background:#e91e63; color:white; border:none; padding:10px 20px; border-radius:8px; cursor:pointer; font-weight:bold; flex:1;">Přijmout</button>
                <button onclick="updateStatus('${order.id}', 'rejected')" style="background:#444; color:white; border:none; padding:10px 20px; border-radius:8px; cursor:pointer; margin-left:10px;">Zamítnout</button>
            `;
        } else if (order.status === 'accepted') {
            actionBtns = `<button onclick="updateStatus('${order.id}', 'ready')" style="background:#2ecc71; color:white; border:none; padding:12px; border-radius:8px; width:100%; font-weight:bold;">HOTOVO - ZABALIT</button>`;
        } else if (order.status === 'ready') {
            actionBtns = `<button onclick="updateStatus('${order.id}', 'shipping')" style="background:#9b59b6; color:white; border:none; padding:12px; border-radius:8px; width:100%; font-weight:bold;">PŘEDAT KURÝROVI (GPS)</button>`;
        } else if (order.status === 'shipping') {
            actionBtns = `<button onclick="updateStatus('${order.id}', 'delivered')" style="background:#2ecc71; color:white; border:none; padding:12px; border-radius:8px; width:100%; font-weight:bold;">POTVRDIT DORUČENÍ</button>`;
        }

        container.innerHTML += `
            <div class="order-card" style="background:#1e1e1e; color:white; margin:15px; padding:20px; border-radius:12px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); border-left: 5px solid #e91e63; width: 350px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                    <h3 style="margin:0; font-size:18px;">#${order.id} - ${order.customerName}</h3>
                    <span style="background:#333; padding:4px 8px; border-radius:4px; font-size:12px; color:#aaa;">${order.status.toUpperCase()}</span>
                </div>
                <ul style="list-style:none; padding:0; margin:0 0 20px 0; color:#ccc; font-size:15px;">
                    ${items}
                </ul>
                <div style="display:flex;">
                    ${actionBtns}
                </div>
            </div>`;
    });
}

function updateStatus(orderId, newStatus) {

    fetch(`https://${GetParentResourceName()}/updateStatus`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            id: orderId,
            status: newStatus
        })
    }).then(resp => resp.json()).then(resp => {
    }).catch(err => {
        console.error("Chyba při odesílání na server:", err);
    });

    // Vizuální schování u doručení/zamítnutí
    if (newStatus === 'delivered' || newStatus === 'rejected') {
        const cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            if (card.innerText.includes("#" + orderId)) {
                card.style.opacity = '0.5'; // Jen pro kontrolu, že JS reaguje
                card.style.display = 'none';
            }
        });
    }
}

// --- POMOCNÉ FUNKCE ---

function showSubPage(pageId) {
    const pages = document.querySelectorAll('.subpage');
    pages.forEach(p => p.style.display = "none");
    const target = document.getElementById(pageId + '-page');
    if (target) target.style.display = "block";
}

function showInternalNotify(msg) {
    const notify = document.getElementById('internal-notify');
    if (notify) {
        notify.innerText = msg;
        notify.style.display = "block";
        setTimeout(() => { notify.style.display = "none"; }, 3000);
    }
}

function closeUI() {
    document.body.style.display = "none";
    fetch(`https://${GetParentResourceName()}/close`, {method: 'POST'});
}

window.onkeydown = function(data) {
    if (data.key === "Escape") closeUI();
};