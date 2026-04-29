window.addEventListener('message', function(event) {
    if (event.data.type === "ui") {
        const container = document.getElementById('container');
        container.style.display = event.data.display ? "block" : "none";
    }
});