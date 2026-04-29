const canvas = document.getElementById('ekg-canvas');
const ctx = canvas.getContext('2d');
let x = 0;
let isUiOpen = false;

// Funkce pro kreslení EKG linky
function drawEKG() {
    // Kreslíme pouze pokud je UI otevřené
    if (!isUiOpen) {
        requestAnimationFrame(drawEKG);
        return;
    }

    // Mírné ztmavení pozadí místo úplného smazání vytvoří efekt "ocasu" linky
    ctx.fillStyle = "rgba(0, 0, 0, 0.05)";
    ctx.fillRect(x, 0, 8, canvas.height);

    ctx.strokeStyle = '#00ecff';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(x, 75);
    
    // Simulace srdečního tepu
    let y = 75;
    if (x % 100 > 40 && x % 100 < 60) {
        y = 75 - Math.random() * 50; // Špička
    }
    
    ctx.lineTo(x + 2, y);
    ctx.stroke();
    
    x += 2;
    if (x > canvas.width) {
        x = 0;
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
    requestAnimationFrame(drawEKG);
}

// Skrytí UI hned při načtení stránky
document.body.style.display = "none";

window.addEventListener('message', function(event) {
    let data = event.data;
    
    // --- OTEVŘENÍ TABLETU ---
    if (data.type === "openUI") {
        isUiOpen = true; // KLÍČOVÁ OPRAVA: Zapne kreslení EKG
        document.body.style.display = "flex";
        document.getElementById('medical-tablet').style.display = "flex";
        document.getElementById('medic-bag-ui').style.display = "none";
        
        if (data.injuries) updateInjuries(data.injuries);
        if (data.pulse) document.getElementById('bpm-value').innerText = data.pulse;
        if (data.bloodPressure) document.getElementById('blood-pressure').innerText = data.bloodPressure;
        if (data.oxygen) document.getElementById('oxygen').innerText = data.oxygen;
    }

    // --- OTEVŘENÍ BATOHU ---
    if (data.type === "openBagUI") {
        isUiOpen = false; // V batohu EKG nepotřebujeme
        document.body.style.display = "flex";
        document.getElementById('medic-bag-ui').style.display = "flex";
        document.getElementById('medical-tablet').style.display = "none";
    }

    // --- ZAVŘENÍ VŠEHO ---
    if (data.type === "closeBagUI" || data.type === "closeUI") {
        isUiOpen = false; // Vypne kreslení
        document.body.style.display = "none";
        document.getElementById('medical-tablet').style.display = "none";
        document.getElementById('medic-bag-ui').style.display = "none";
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        x = 0;
    }
});

// html/script.js

// html/script.js

window.addEventListener('message', function(event) {
    let data = event.data;

    // Standardní otevření UI (to už máš)
    if (data.type === "openUI") {
        openTablet(data);
    }

    // NOVÉ: Live aktualizace hodnot
    if (data.type === "updateVitals") {
        // Najdeme elementy podle ID (ujisti se, že ID v HTML sedí!)
        const pulseElem = document.getElementById('pulse-value');
        const oxygenElem = document.getElementById('oxygen-value');
        const pressureElem = document.getElementById('pressure-value');

        if (pulseElem) pulseElem.innerText = data.pulse;
        if (oxygenElem) oxygenElem.innerText = data.oxygen + "%";
        if (pressureElem) pressureElem.innerText = data.bloodPressure;

        // Vizuální efekt: Pokud tep letí nahoru, změníme barvu na červenou
        if (data.pulse > 140 || data.pulse < 50) {
            pulseElem.style.color = "#ff4444";
        } else {
            pulseElem.style.color = "#00ff00";
        }
    }
});

function updateInjuries(injuries) {
    const list = document.getElementById('injury-list');
    const markerContainer = document.getElementById('injury-markers');
    
    list.innerHTML = '<h3>DETEKCE TRAUMAT:</h3>';
    markerContainer.innerHTML = '';

    if (!injuries || injuries.length === 0) {
        list.innerHTML += '<p class="no-injury">Žádná viditelná zranění.</p>';
        return;
    }

    injuries.forEach(inj => {
        let p = document.createElement('p');
        p.innerText = `⚠️ ${inj.type} - ${inj.part}`;
        p.className = "injury-text"; // Lepší použít třídu v CSS než inline style
        p.style.color = "red";
        p.style.margin = "5px 0";
        p.style.fontSize = "0.9rem";
        list.appendChild(p);

        let dot = document.createElement('div');
        dot.className = 'injury-dot';
        dot.style.left = inj.x + "%"; 
        dot.style.top = inj.y + "%";
        markerContainer.appendChild(dot);
    });
}

function closeUI() {
    isUiOpen = false;
    document.body.style.display = "none";
    x = 0;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

// Nastavení canvasu
canvas.width = 350;
canvas.height = 150;
drawEKG();

function startTreatment() {
    document.body.style.display = "none";
    isUiOpen = false;

    fetch(`https://${GetParentResourceName()}/startMedicalAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

// Upravená funkce pro kliknutí na položku v batohu
function takeItem(itemName) {
    // 1. Nejdřív zavřeme UI v JavaScriptu
    document.getElementById('medic-bag-ui').style.display = 'none';
    document.body.style.display = "none";

    // 2. Pošleme informaci do Lua (tento fetch musí existovat!)
    fetch(`https://${GetParentResourceName()}/takeBagItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            item: itemName
        })
    });
}

// Funkce pro ruční zavření batohu (tlačítkem)
function closeBag() {
    document.getElementById('medic-bag-ui').style.display = 'none';
    document.body.style.display = "none";
    
    // Musíme hře říct, že chceme myš pryč
    fetch(`https://${GetParentResourceName()}/closeBag`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

function closeBag() {
    // 1. Schováme UI prvky
    document.getElementById('medic-bag-ui').style.display = 'none';
    document.body.style.display = "none";
    isUiOpen = false;

    // 2. POŠLEME SIGNÁL DO LUA, ABY VYPNULO MYŠ
    fetch(`https://${GetParentResourceName()}/closeBag`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function updateInjuries(injuries) {
    const list = document.getElementById('injury-list');
    const markerContainer = document.getElementById('injury-markers');
    
    list.innerHTML = '<h3>DETEKCE TRAUMAT:</h3>';
    markerContainer.innerHTML = '';

    if (!injuries || injuries.length === 0) {
        list.innerHTML += '<p class="no-injury">Pacient je stabilizován.</p>';
        return;
    }

    injuries.forEach((inj, index) => {
        // Vytvoření řádku zranění
        let div = document.createElement('div');
        div.className = 'injury-row';
        div.style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; background: rgba(255,0,0,0.1); padding: 5px; border-radius: 5px;";
        
        div.innerHTML = `
            <span>⚠️ ${inj.type} (${inj.part})</span>
            <button class="btn treat-btn" onclick="treatInjury(${index}, '${inj.type}')" style="padding: 5px 10px; font-size: 0.7rem;">OŠETŘIT</button>
        `;
        list.appendChild(div);

        // Tečka na těle
        let dot = document.createElement('div');
        dot.className = 'injury-dot';
        dot.style.left = inj.x + "%"; 
        dot.style.top = inj.y + "%";
        markerContainer.appendChild(dot);
    });
}

// Funkce volaná po kliknutí na tlačítko v tabletu
function treatInjury(index, type) {
    // Pošleme do Lua požadavek na ošetření konkrétního zranění
    fetch(`https://${GetParentResourceName()}/processTreatment`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({
            injuryIndex: index + 1, // Lua indexuje od 1
            injuryType: type
        })
    });
}

function closeTablet() {
    // Schová HTML
    document.getElementById('medic-tablet').style.display = 'none';
    
    // POSÍLÁ DO LUA - tohle vypne tu myš!
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

