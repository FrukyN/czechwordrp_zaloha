let isBoss = false;
let isPolice = false;

// =====================================================
// OTEVŘENÍ UI
// =====================================================

window.addEventListener('message', function(event) {

    if (event.data.action === "open") {

        document.getElementById('app').classList.remove('hidden');

        const data = event.data.data;
        isBoss = data.isBoss;
        isPolice = data.job === 'police';

        renderMyBills(data.bills);

        // Povolení vystavování
        if (data.canBill) {
            document.getElementById('createSection').classList.remove('hidden');
        } else {
            document.getElementById('createSection').classList.add('hidden');
        }

        // Boss záložka
        if (data.canBill) {
            document.getElementById('tabSociety').classList.remove('hidden');
        } else {
            document.getElementById('tabSociety').classList.add('hidden');
        }

        // Police záložka
        if (isPolice) {
            document.getElementById('tabExecutions').classList.remove('hidden');
        } else {
            document.getElementById('tabExecutions').classList.add('hidden');
        }

        showTab('my');
    }

    if (event.data.action === "openSociety") {
        renderSocietyBills(event.data.data);
    }

    if (event.data.action === "openExecutions") {
        renderExecutions(event.data.data);
    }
});


// =====================================================
// STATUS HELPER
// =====================================================

function getStatusInfo(status) {

    if (status === 'paid') {
        return { label: 'ZAPLACENO', class: 'status-paid' };
    }

    if (status === 'in_execution') {
        return { label: 'V EXEKUCI', class: 'status-overdue' };
    }

    if (status === 'paid_execution') {
        return { label: 'SPLACENO (EXEKUCE)', class: 'status-paid' };
    }

    return { label: 'NEZAPLACENO', class: 'status-unpaid' };
}


// =====================================================
// RENDER MOJE FAKTURY
// =====================================================

function renderMyBills(bills) {

    const billsDiv = document.getElementById('bills');
    billsDiv.innerHTML = '';

    bills.forEach(bill => {

        const statusInfo = getStatusInfo(bill.status);

        const jobNames = {
            police: "Policie",
            ambulance: "Záchranka",
            mechanic: "Mechanik",
            stk: "STK",
            bar: "Bar"
        };

        const jobLabel = jobNames[bill.sender_job] || bill.sender_job;

        const date = new Date(bill.created_at);
        const formattedDate = date.toLocaleString('cs-CZ');

        const remainingText = bill.remaining_amount && bill.remaining_amount > 0
            ? `<br><small>Zbývá doplatit: <b>$${bill.remaining_amount}</b></small>`
            : '';

        billsDiv.innerHTML += `
            <div class="bill-card">
                <div>
                    <strong>$${bill.amount}</strong>
                    <p>${bill.reason}</p>
                    <small>
                        Od frakce: <b>${jobLabel}</b><br>
                        Datum: ${formattedDate}
                    </small>
                    ${remainingText}
                    <br>
                    <span class="status ${statusInfo.class}">
                        ${statusInfo.label}
                    </span>
                </div>
                ${bill.status === 'unpaid' || bill.status === 'in_execution' ? `
                    <div>
                        <button onclick="pay(${bill.id}, 'cash')">Cash</button>
                        <button onclick="pay(${bill.id}, 'bank')">Bank</button>
                    </div>
                ` : ''}
            </div>
        `;
    });
}


// =====================================================
// RENDER FRAKČNÍ FAKTURY
// =====================================================

function renderSocietyBills(bills) {

    const container = document.getElementById('societyBills');
    container.innerHTML = '';

    bills.forEach(bill => {

        const statusInfo = getStatusInfo(bill.status);

        const senderName = bill.sender_firstname 
            ? bill.sender_firstname + ' ' + bill.sender_lastname 
            : 'Neznámý';

        const targetName = bill.target_firstname 
            ? bill.target_firstname + ' ' + bill.target_lastname 
            : 'Neznámý';

        const date = new Date(bill.created_at);
        const formattedDate = date.toLocaleString('cs-CZ');

        container.innerHTML += `
            <div class="bill-card">
                <div>
                    <strong>$${bill.amount}</strong>
                    <p>${bill.reason}</p>
                    <small>
                        Vystavil: ${senderName}<br>
                        Komu: ${targetName}<br>
                        Datum: ${formattedDate}
                    </small>
                    <br>
                    <span class="status ${statusInfo.class}">
                        ${statusInfo.label}
                    </span>
                </div>
            </div>
        `;
    });
}


// =====================================================
// RENDER EXEKUCÍ (POLICIE)
// =====================================================

function renderExecutions(list) {

    const container = document.getElementById('executionList');
    container.innerHTML = '';

    list.forEach(entry => {

        const date = new Date(entry.execution_started_at);
        const formattedDate = date.toLocaleString('cs-CZ');

        container.innerHTML += `
            <div class="bill-card">
                <div>
                    <strong>${entry.firstname} ${entry.lastname}</strong>
                    <p>Původní částka: $${entry.amount}</p>
                    <p>Zbývá: $${entry.remaining_amount}</p>
                    <small>V exekuci od: ${formattedDate}</small>
                </div>
            </div>
        `;
    });
}


// =====================================================
// ZÁLOŽKY
// =====================================================

function showTab(tab) {

    document.getElementById('mySection').classList.add('hidden');
    document.getElementById('societySection').classList.add('hidden');
    document.getElementById('executionSection').classList.add('hidden');

    document.getElementById('tabMy').classList.remove('active');
    document.getElementById('tabSociety').classList.remove('active');
    document.getElementById('tabExecutions').classList.remove('active');

    if (tab === 'my') {
        document.getElementById('mySection').classList.remove('hidden');
        document.getElementById('tabMy').classList.add('active');
    }

    if (tab === 'society') {
        document.getElementById('societySection').classList.remove('hidden');
        document.getElementById('tabSociety').classList.add('active');

        fetch(`https://${GetParentResourceName()}/requestSociety`, {
            method: 'POST'
        });
    }

    if (tab === 'executions') {
        document.getElementById('executionSection').classList.remove('hidden');
        document.getElementById('tabExecutions').classList.add('active');

        fetch(`https://${GetParentResourceName()}/requestExecutions`, {
            method: 'POST'
        });
    }
}


// =====================================================
// ACTIONS
// =====================================================

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    document.getElementById('app').classList.add('hidden');
}

function pay(id, method) {
    fetch(`https://${GetParentResourceName()}/pay`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({id: id, method: method})
    });
}

function createBill() {
    fetch(`https://${GetParentResourceName()}/create`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            targetId: document.getElementById('targetId').value,
            amount: document.getElementById('amount').value,
            reason: document.getElementById('reason').value
        })
    });
}

function loadNearbyPlayers() {
    fetch(`https://${GetParentResourceName()}/getNearbyPlayers`, {
        method: 'POST'
    });
}

window.addEventListener('message', function(event) {

    if (event.data.action === "showNearbyPlayers") {

        const container = document.getElementById('nearbyPlayers');
        container.classList.remove('hidden');
        container.innerHTML = '';

        event.data.data.forEach(player => {

            container.innerHTML += `
                <div class="player-select" onclick="selectPlayer(${player.id}, '${player.name}')">
                    ${player.name}
                </div>
            `;
        });
    }
});

function selectPlayer(id, name) {
    document.getElementById('targetId').value = id;
    document.getElementById('nearbyPlayers').classList.add('hidden');
}

// ESC zavření
document.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
        closeUI();
    }
});