window.addEventListener('message', function(event) {
    if (event.data.action === "playAlarm") {
        const d = event.data.info;
        
        // Přepnutí obrazovek
        document.getElementById('idle-ui').classList.add('hidden');
        document.getElementById('emergency-ui').classList.remove('hidden');

        // Naplnění dat
        document.getElementById('title').innerText = d.title || "POŽÁR";
        document.getElementById('location').innerText = d.location || "Neznámá ulice";
        document.getElementById('msg').innerText = d.msg || "Výjezd techniky";

        // --- PROSTOROVÝ ZVUK ---
        let audio = new Audio('sounds/alarm.ogg');
        audio.volume = event.data.volume || 0.5;
        audio.play().catch(e => console.log("Chyba audia:", e));

        // --- HLASOVÉ HLÁŠENÍ (TTS) ---
        setTimeout(() => {
            window.speechSynthesis.cancel();
            let veta = `Pozor, výjezd. ${d.title}. Místo události: ${d.location}.`;
            let hst = new SpeechSynthesisUtterance(veta);
            hst.lang = 'cs-CZ';
            hst.rate = 0.85;
            window.speechSynthesis.speak(hst);
        }, 3500); // Začne mluvit po 3.5s pípání

        // Automatický návrat do klidu po 90 sekundách
        setTimeout(() => {
            document.getElementById('idle-ui').classList.remove('hidden');
            document.getElementById('emergency-ui').classList.add('hidden');
            window.speechSynthesis.cancel();
        }, 90000);
    }
});