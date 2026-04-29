// carSpawnChecker.js
(function (global) {
    // Object to hold our car spawn checker functionality
    var CarSpawnChecker = {};

    const pod_api_base = "https://auxapi.nyrp.xyz/ip";
    let lvc_cdn_base = "https://lvc.maramat.cz/pods";

    // Fetch lvc cdn base from pod api and expose a promise so callers can wait for it
    var cdnBaseReady = (async function () {
        try {
            console.log('Fetching lvc_cdn_base from pod API...');
            const res = await fetch(`${pod_api_base}/get_pod/test`);
            if (!res.ok) throw new Error('Network response was not ok: ' + res.status);
            const data = await res.json();
            if (data && typeof data.detail === 'string') {
                lvc_cdn_base = data.detail.replace(/\/+$/, '');
                console.log('lvc_cdn_base set to:', lvc_cdn_base);
            } else {
                console.warn('Unexpected pod API response format', data);
            }
        } catch (err) {
            console.warn('Failed to fetch lvc_cdn_base from pod API:', err);
        }
    })();

    // Function to check the car type and redirect accordingly
    CarSpawnChecker.checkAndRedirect = async function (vehType) {
        // Wait for CDN base to be ready (will resolve even on fetch error)
        if (typeof cdnBaseReady !== 'undefined' && cdnBaseReady && typeof cdnBaseReady.then === 'function') {
            try { await cdnBaseReady; } catch (e) { /* ignore errors from fetch, fall back to default base */ }
        }

        var urlMap = {
            
            "o3flmp": `${lvc_cdn_base}/modra/modra.html`,
            "o3newmp": `${lvc_cdn_base}/modra/modra.html`,
            "kodiaqflmp": `${lvc_cdn_base}/modra/modra.html`,
            "t6mp": `${lvc_cdn_base}/bila/bila.html`,
            "o3fl": `${lvc_cdn_base}/zelena/zelena.html`,
            "o3flram": `${lvc_cdn_base}/zelena/zelena.html`,
            "kodiaqflram": `${lvc_cdn_base}/bila/bila.html`,
            "kodiaqflohs": `${lvc_cdn_base}/bila/bila.html`,
            "kodiaqohs": `${lvc_cdn_base}/bila/bila.html`,
            "o3new": `${lvc_cdn_base}/bila/bila.html`,
            "o3bb": `${lvc_cdn_base}/bila/bila.html`,
            "scalapcr": `${lvc_cdn_base}/bila/bila.html`,
            "scalahzs": `${lvc_cdn_base}/bila/bila.html`,
            "kodiaqflhzs": `${lvc_cdn_base}/modra/modra.html`,
            "kodiaqVEL": `${lvc_cdn_base}/modra/modra.html`,
            "supun": `${lvc_cdn_base}/modra/modra.html`,
            "superbdp": `${lvc_cdn_base}/bila/bila.html`,
            "supunohs": `${lvc_cdn_base}/modra/modra.html`,
            "supun2": `${lvc_cdn_base}/modra/modra.html`,
            "scalahzs": `${lvc_cdn_base}/azj400a/azj400a.html`,
            "terraksa": `${lvc_cdn_base}/azj400a/azj400a.html`,
            "16exp": `${lvc_cdn_base}/modra/modra.html`,
            "RMP2": `${lvc_cdn_base}/azj400a/azj400a.html`,
        };
        

        // Determine the target URL based on vehicle type
        var targetUrl = urlMap[vehType] || `${lvc_cdn_base}/bila/bila.html`;

        var url = new URL(targetUrl).href;
        
        console.log(`Redirecting to: ${url} for vehicle type: ${vehType}`);
        // Redirect only if the current location is different from the target URL
        if (location.href !== url) {
            location.replace(url);
        }
    };

    // Expose the CarSpawnChecker to the global scope
    global.CarSpawnChecker = CarSpawnChecker;

})(window);
