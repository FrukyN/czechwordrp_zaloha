// Pomocná funkce pro hlasové hlášení
function mluv(text) {
    window.speechSynthesis.cancel();
    let hst = new SpeechSynthesisUtterance(text);
    hst.lang = 'cs-CZ';
    hst.rate = 0.85; // Mírně pomalejší tempo
    hst.pitch = 1.0;
    hst.volume = 1.0;
    window.speechSynthesis.speak(hst);
}

window.addEventListener('message', function(event) {
    if (event.data.action === "playAlarm") {
        var data = event.data.info;

        // 1. VYPLNĚNÍ MONITORU
        const titleEl = document.getElementById('title');
        const locEl = document.getElementById('loc');

        if (titleEl) titleEl.innerText = data.title || "POPLACH - VÝJEZD";
        if (locEl) locEl.innerText = data.location || "Neznámá lokalita";

        // Zobrazení panelu
        const panel = document.getElementById('station-display');
        if (panel) panel.classList.remove('hidden');

        // 2. SPUŠTĚNÍ SIRÉNY (Hraje hned)
        var audio = new Audio('https://cfx-nui-esx_fireDispatch/sounds/alarm.ogg');
        audio.volume = 0.5;
        audio.play().catch(e => console.log("Chyba audia:", e));

        // 3. HLASOVÉ HLÁŠENÍ PO 25 SEKUNDÁCH
        setTimeout(function() {
            // Nejdřív si připravíme čisté texty, aby tam nebylo "undefined"
            let typUdalosti = data.title || "Tísňové volání";
            let mistoUdalosti = data.location || "Neznámá adresa";
            let zpravaOdHrace = data.msg || "nejsou známy";

            // TADY TO SPOJÍME DO JEDNÉ VELKÉ VĚTY NAJEDNOU
            // Použijeme backticks (tyto zpětné čárky ` `), které jsou ve JS nejspolehlivější
            let finalniVeta = `Pozor, vyhlášen poplach pro jednotku. Typ události: ${typUdalosti}. Místo události: ${mistoUdalosti}. Doplňující informace: ${zpravaOdHrace}. Výjezd techniky potvrzen.`;

            // DEBUG do F8 (nui_devtools), abys viděl, co to přesně posílá do repráků
            console.log("Hlášení: " + finalniVeta);

            // Pokud monitor pořád svítí (nebyl mezitím vypnut), tak mluv
            if (panel && !panel.classList.contains('hidden')) {
                mluv(finalniVeta);
            }
        }, 25000);

        // 4. SCHOVÁNÍ MONITORU (Po 60s)
        setTimeout(() => {
            if (panel) panel.classList.add('hidden');
            window.speechSynthesis.cancel();
        }, 60000);
    }
});