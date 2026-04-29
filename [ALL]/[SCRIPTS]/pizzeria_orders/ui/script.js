window.addEventListener('message', function(event) {
    const ticket = document.getElementById('order-ticket');
    const statusText = document.getElementById('status-text');

    if (event.data.action === 'show_ticket') {
        // Data
        document.getElementById('ticket-id').innerText = "#" + event.data.id;
        document.getElementById('ticket-items').innerText = event.data.items.join(", ");
        
        updateStatusUI(event.data.status);

        // Zobrazení a vyjetí
        ticket.style.display = "block";
        setTimeout(() => {
            ticket.style.right = "0px";
        }, 100);
    } 
    
    else if (event.data.action === 'update_ticket') {
        updateStatusUI(event.data.status);
    } 
    
    else if (event.data.action === 'hide_ticket') {
        ticket.style.right = "-350px";
        setTimeout(() => {
            ticket.style.display = "none";
        }, 700);
    }
});

function updateStatusUI(status) {
    const el = document.getElementById('status-text');
    if (status === 'preparing') {
        el.innerText = "V PŘÍPRAVĚ";
        el.className = "status-preparing";
    } else {
        el.innerText = "HOTOVO - VYZVEDNOUT!";
        el.className = "status-ready";
    }
}