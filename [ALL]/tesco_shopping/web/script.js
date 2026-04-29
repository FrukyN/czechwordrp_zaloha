let total = 0;

window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "showUI") {
        document.getElementById('basket-ui').style.display = 'block';
    } else if (data.action === "hideUI") {
        document.getElementById('basket-ui').style.display = 'none';
        document.getElementById('item-list').innerHTML = '';
        total = 0;
    } else if (data.action === "addItem") {
        total += data.item.price;
        const div = document.createElement('div');
        div.className = 'item-row';
        div.innerHTML = `<span>${data.item.label}</span><span>${data.item.price} Kč</span>`;
        document.getElementById('item-list').appendChild(div);
        document.getElementById('total-price').innerText = total + " Kč";
    }
});