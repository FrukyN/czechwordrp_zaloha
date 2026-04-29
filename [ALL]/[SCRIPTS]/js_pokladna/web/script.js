let basket = [];
let total = 0;

window.addEventListener('message', function(event) {
    const d = event.data;
    if (d.type === "openPOS") {
        resetData();
        document.getElementById('wrapper').style.display = 'flex';
        document.getElementById('seller-ui').style.display = 'block';
        document.getElementById('customer-ui').style.display = 'none';
        
        const grid = document.getElementById('grid');
        grid.innerHTML = d.items.map(i => `
            <div class="grid-item" onclick="add('${i.label}',${i.price},'${i.name}')">
                ${i.label}<br>${i.price} CZK
            </div>
        `).join('');
    } else if (d.type === "openCustomerReceipt") {
        document.getElementById('wrapper').style.display = 'flex';
        document.getElementById('seller-ui').style.display = 'none';
        document.getElementById('customer-ui').style.display = 'block';
        document.getElementById('c-total').innerText = d.total;
        total = d.total; 
        basket = d.items;
        document.getElementById('c-list').innerHTML = d.items.map(i => `<div>${i.label} - ${i.price} CZK</div>`).join('');
    }
});

function add(label, price, name) {
    basket.push({label, price, name});
    total += price;
    document.getElementById('receipt-list').innerHTML = basket.map(i => `<div>${i.label} - ${i.price} CZK</div>`).join('');
    document.getElementById('s-total').innerText = total;
}

function confirm() {
    if (basket.length === 0) return;
    
    // Animace papíru
    document.getElementById('fx-content').innerHTML = basket.map(i => `<div>${i.label} - ${i.price} CZK</div>`).join('');
    document.getElementById('fx-total').innerText = total + " CZK";
    document.getElementById('receipt-fx').classList.add('printing');

    setTimeout(() => {
        fetch(`https://${GetParentResourceName()}/confirmBill`, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({items: basket, total: total})
        });
        closeApp();
    }, 1000);
}

function pay(method) {
    fetch(`https://${GetParentResourceName()}/payBill`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({method: method, total: total})
    });
    closeApp();
}

function resetData() {
    basket = [];
    total = 0;
    document.getElementById('s-total').innerText = '0';
    document.getElementById('receipt-list').innerHTML = '';
    document.getElementById('receipt-fx').classList.remove('printing');
}

function closeApp() {
    document.getElementById('wrapper').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeUI`, {method: 'POST'});
}