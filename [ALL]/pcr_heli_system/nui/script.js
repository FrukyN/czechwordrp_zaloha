window.addEventListener('message', function(event) {
    let data = event.data;

    // 1. Zobrazení / Skrytí UI
    if (data.action === "showUI") {
        const uiElement = document.getElementById('heli-ui');
        uiElement.style.display = data.state ? "block" : "none";
        
        // Při zapnutí rovnou aktualizujeme datum
        if (data.state) {
            let today = new Date();
            let dd = String(today.getDate()).padStart(2, '0');
            let mm = String(today.getMonth() + 1).padStart(2, '0'); // Leden je 0
            let yy = today.getFullYear().toString().substr(-2);
            document.getElementById('date').innerText = dd + "/" + mm + "/" + yy;
        }
    }

    // 2. Hlavní aktualizace (Výška, Rychlost, Kompas, Čas)
    if (data.action === "update") {
        // Výška
        if (data.alt !== undefined) {
            document.getElementById('alt').innerText = Math.floor(data.alt);
        }

        // Rychlost
        if (data.speed !== undefined) {
            document.getElementById('speed').innerText = Math.floor(data.speed);
        }

        // Heading (Stupně v textu)
        if (data.heading !== undefined) {
            document.getElementById('heading').innerText = Math.floor(data.heading);
            
            // POHYB KOMPASU (Klíčová část)
            const compassPruh = document.getElementById('compass-pruh');
            if (compassPruh) {
                // 2.08 je konstanta pro plynulý posun, doladíme podle CSS letter-spacing
                let offset = data.heading * 2.08; 
                compassPruh.style.transform = `translateX(${-offset}px)`;
            }
        }
        
        // Hodiny (Reálný čas)
        const now = new Date();
        const timeStr = now.getHours().toString().padStart(2, '0') + ":" + 
                        now.getMinutes().toString().padStart(2, '0') + ":" + 
                        now.getSeconds().toString().padStart(2, '0');
        document.getElementById('time').innerText = timeStr;
    }

    // 3. Scanner vozidel (SPZ a Model)
    if (data.action === "updateTarget") {
        const modelElement = document.getElementById('model');
        const plateElement = document.getElementById('plate');

        if (data.model && data.model !== "NULL") {
            modelElement.innerText = data.model.toUpperCase();
            modelElement.style.color = "#00ff00"; 
        } else {
            modelElement.innerText = "SEARCHING...";
            modelElement.style.color = "#ffffff";
        }

        if (data.plate) {
            plateElement.innerText = data.plate;
            plateElement.style.color = "#ffff00"; 
        } else {
            plateElement.innerText = "-------";
            plateElement.style.color = "#ffffff";
        }
    }

    // 4. Status světla
    if (data.action === "updateStatus") {
        const light = document.getElementById('light-status');
        if (light) {
            light.innerText = data.spotlight ? "ON" : "OFF";
            light.style.color = data.spotlight ? "#00ff00" : "#ff0000";
        }
    }
});

// Tvůj glitch efekt (necháváme, vypadá to dobře)
setInterval(() => {
    const ui = document.getElementById('heli-ui');
    if (ui && ui.style.display === "block") {
        ui.style.opacity = (Math.random() * (1.0 - 0.98) + 0.98).toString();
    }
}, 50);