window.addEventListener('message', function(event) {
    const tablet = document.getElementById('tablet');
    
    // AKTUALIZACE A ZOBRAZENÍ TABLETU
    if (event.data.action === "update") {
        // Zobrazíme tablet (HUD režim)
        tablet.style.display = "block";
        
        // Nastavení SPZ vozidla
        if (event.data.plate) {
            document.getElementById('plate').innerText = event.data.plate;
        }
        
        // Vyčištění a znovuvytvoření seznamu
        let list = document.getElementById('list');
        list.innerHTML = "";
        
        if (event.data.points) {
            event.data.points.forEach(p => {
                let statusText = "ČEKÁ";
                let statusClass = "status-wait";
                let icon = "fa-spinner fa-spin"; // Točící se kolečko pro čekání
                
                if (p.status === true) { 
                    statusText = "V POŘÁDKU"; 
                    statusClass = "status-ok"; 
                    icon = "fa-check-circle"; // Zelená fajfka
                } else if (p.status === false) { 
                    statusText = "ZÁVADA"; 
                    statusClass = "status-bad"; 
                    icon = "fa-exclamation-triangle"; // Červený trojúhelník
                }
                
                // Vložíme řádek do seznamu
                list.innerHTML += `
                    <div class="item">
                        <div class="item-info">
                            <i class="fas ${icon} ${statusClass}"></i>
                            <span style="margin-left: 10px;">${p.label}</span>
                        </div>
                        <span class="${statusClass}">${statusText}</span>
                    </div>
                `;
            });
        }
    } 
    
    // SCHOVÁNÍ TABLETU (Voláno z Finalize v client.lua)
    else if (event.data.action === "hide") {
        tablet.style.display = "none";
    }
});

// FUNKCE PRO REÁLNÉ HODINY V TABLETU
function updateClock() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const clockEl = document.getElementById('clock');
    if (clockEl) {
        clockEl.innerText = hours + ":" + minutes;
    }
}

// Spuštění hodin
setInterval(updateClock, 1000);
updateClock();