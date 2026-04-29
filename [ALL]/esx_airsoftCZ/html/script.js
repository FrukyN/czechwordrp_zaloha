let currentArenaId = null;

window.addEventListener('message', function(event) {
    let item = event.data;

    // Otevření lobby
    if (item.action === "openLobby") {
        document.getElementById('lobby-container').style.display = "block";
        document.getElementById('arena-label').innerHTML = item.label;
        document.getElementById('arena-price').innerHTML = "Cena vstupu: " + item.price + " CZK";
        currentArenaId = item.arenaId;
    }

    if (item.action === "announce") {
    let el = document.getElementById('announcement');
    document.getElementById('announcement-title').innerHTML = item.title;
    document.getElementById('announcement-subtitle').innerHTML = item.subtitle;

    el.style.display = "block";
    setTimeout(() => { 
        el.style.transform = "scaleX(1)"; // Animace roztažení
    }, 100);

    // Po 5 sekundách to zase schováme
    setTimeout(() => {
        el.style.transform = "scaleX(0)";
        setTimeout(() => { el.style.display = "none"; }, 500);
    }, 5000);
}

    // Zobrazení HUDu
    if (item.action === "showHUD") {
        document.getElementById('game-hud').style.display = "block";
        document.getElementById('lobby-container').style.display = "none";
    }

    // SKÓRE: Aktualizace bodů (modrá vs červená)
    if (item.action === "updateScore") {
        // Ujisti se, že v HTML máš id="blue-pts" a id="red-pts"
        if (document.getElementById('blue-pts')) document.getElementById('blue-pts').innerHTML = item.blue;
        if (document.getElementById('red-pts')) document.getElementById('red-pts').innerHTML = item.red;
    }

    // ČAS: Aktualizace odpočtu času (timer)
        if (item.action === "updateTime") {
        let timerEl = document.getElementById('timer-text');
        if (timerEl) {
            timerEl.innerHTML = item.time;
        }
    }

    // STATUS: V BOJI (green) / OUT (red)
    if (item.action === "status") {
        let el = document.getElementById('status-text');
        if (el) {
            el.innerHTML = item.text;
            // Barvy podle tvého HUDu
            el.style.color = item.color === "red" ? "#ff3c00" : "#00ff88";
        }
    }

    // KILLFEED: Kdo zabil koho
    if (item.action === "killfeed") {
        const feed = document.getElementById('killfeed');
        if (feed) {
            const msg = document.createElement('div');
            msg.className = 'kill-msg';
            msg.innerHTML = `<b>${item.attacker}</b> 🔫 ${item.victim}`;
            feed.appendChild(msg);
            setTimeout(() => { msg.style.opacity = '0'; setTimeout(() => msg.remove(), 500); }, 5000);
        }
    }

    // SKRYTÍ HUDu (při odchodu /exitairsoft)
    if (item.action === "hideHUD") {
        document.getElementById('game-hud').style.display = "none";
        if (document.getElementById('exit-hint')) {
            document.getElementById('exit-hint').style.display = "none";
        }
    }
});

// Funkce pro kliknutí na tlačítka týmů v HTML
function joinTeam(teamName) {
    fetch(`https://${GetParentResourceName()}/joinTeam`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ team: teamName, arenaId: currentArenaId })
    });
}

function closeMenu() {
    document.getElementById('lobby-container').style.display = "none";
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    });
}

document.onkeyup = function (data) {
    if (data.which == 27) { // ESC klávesa
        closeMenu();
    }
};