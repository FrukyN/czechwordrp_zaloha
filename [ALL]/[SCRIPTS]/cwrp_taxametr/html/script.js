let totalAmount = 0;

window.addEventListener("message", function(event) {
    if (event.data.action === "open") {
        document.getElementById("taxametr").classList.remove("hidden");
    }

    if (event.data.action === "setAutoValues") {
    document.getElementById("km").value = event.data.km.toFixed(2);
    totalAmount = event.data.total;
    document.getElementById("total").innerText = totalAmount.toFixed(0) + " Kč";
    }

    if (event.data.action === "hideUI") {
    document.getElementById("taxametr").classList.add("hidden");
}

if (event.data.action === "showFinal") {
    document.getElementById("taxametr").classList.remove("hidden");

    document.getElementById("km").value = event.data.km.toFixed(2);
    totalAmount = event.data.total;
    document.getElementById("total").innerText = totalAmount.toFixed(0) + " Kč";
}

if (event.data.action === "updateHUD") {
    document.getElementById("taxiHUD").classList.remove("hidden");

    document.getElementById("hudPrice").innerText =
        event.data.total.toFixed(0) + " Kč";

    document.getElementById("hudKm").innerText =
        event.data.km.toFixed(2) + " km";
}

if (event.data.action === "hideHUD") {
    document.getElementById("taxiHUD").classList.add("hidden");
}

});

function calculate() {
    let base = parseFloat(document.getElementById("base").value) || 0;
    let km = parseFloat(document.getElementById("km").value) || 0;
    let perkm = parseFloat(document.getElementById("perkm").value) || 0;
    let waiting = parseFloat(document.getElementById("waiting").value) || 0;

    totalAmount = base + (km * perkm) + waiting;
    document.getElementById("total").innerText = totalAmount.toFixed(0) + " Kč";
}

function bill() {
    fetch(`https://${GetParentResourceName()}/bill`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            total: totalAmount,
            km: parseFloat(document.getElementById("km").value) || 0,
            base: parseFloat(document.getElementById("base").value) || 0,
            perkm: parseFloat(document.getElementById("perkm").value) || 0,
            waiting: parseFloat(document.getElementById("waiting").value) || 0
        })
    });
}

function resetMeter() {
    totalAmount = 0;
    document.getElementById("total").innerText = "0 Kč";
}

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    });

    document.getElementById("taxametr").classList.add("hidden");
}

function startRide() {
    fetch(`https://${GetParentResourceName()}/startRide`, { method: "POST" });
}

function stopRide() {
    fetch(`https://${GetParentResourceName()}/stopRide`, { method: "POST" });
}