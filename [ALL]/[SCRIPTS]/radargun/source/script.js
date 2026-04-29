$(function() {
    window.addEventListener("message", function(event) {
        const item = event.data;

        // show or hide #radarGun
        if (item.type == "display") {
            if (item.status) {
                if (item.firstPerson) {
                    $("#radarGun").fadeOut("slow");
                } else {
                    $("#radarGun").fadeIn("slow");
                }
            } else {
                $("#radarGun").fadeOut("slow");
                $("#gunReticle").fadeOut("fast");
            };
        };

        // show or hide #gunScope
        if (item.type == "scope") {
            if (item.status)
                $("#gunScope").show();
            else {
                $("#gunScope").hide();
            };
        };

        // show or hide reticle
        if (item.type == "aim") {
            if (item.status)
                $("#gunReticle").show();
            else {
                $("#gunReticle").hide();
            };
        };

        if (item.type == "dui") {
            if (item.status) {
                $("#dui").show();
            } else {
                $("#dui").hide();
            };
        }

        // show all the other features
        if (item.type == "updateData") {
            $(".speed").text(item.speed);
            $(".range").text(item.range);
            $(".speedPrefix").text(item.speedPrefix);
            $(".rangePrefix").text(item.rangePrefix);
            $(".plate").text(item.plate);
            $(".triggeredSpeed").text(item.triggeredSpeed);
            $("#scopeSpeed").text(item.speed);
            
            if (item.indicator == "▲") {
                $(".speedIndicator").css("color", "#be0505")
            } else {
                $(".speedIndicator").css("color", "#0eac1b")
            }
            $(".speedIndicator").text(item.indicator);
        };
        
    });
});