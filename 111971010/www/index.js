$(document).ready(function () {
    $(".button-group .button input").on("click", function () {
        $(this).parent().siblings(".button.active").removeClass("active");
        $(this).parent().addClass("active");
        let target = $(this).data('rel');
        $("[name=" + target + "][value=" + $(this).val() + "]").parent().siblings(".button").show();
        $("[name=" + target + "][value=" + $(this).val() + "]").parent().hide();
    });

    $("#refresh").on("click", function() {
        $("#seed_setting").val(Math.floor(Math.random() * 1000)).trigger("change");
    });

    var slider = $("#slider");
    function listener() {
        $("#tooltip_silder_num").html(slider.val());
        var value = ((slider.val() - slider.attr("min")) / (slider.attr("max") - slider.attr("min"))) * 100;
        slider.css("background", "linear-gradient(to right, #10d5c2 0%, #10d5c2 " + value + "%, #eaeefb " + value + "%, #eaeefb 100%)");
    }
    
    slider.mousedown(function () {
        listener();
        slider.mousemove(listener);
    });
    
    slider.mouseup(function () {
        $("#sample_n_input").val(slider.val()).trigger("change");
        slider.off("mousemove", listener);
    });
    
    slider.keydown(listener);
    
    slider.on("input", function () {
        listener();
    });
});

// let slider = document.getElementById("slider");
// slider.addEventListener("mousedown", function () {
//     listener();
//     slider.addEventListener("mousemove", listener);
// });
// slider.addEventListener("mouseup", function () {
//     slider.removeEventListener("mousemove", listener);
// });
  
// slider.addEventListener("keydown", listener);
  
// slider.oninput = function () {
//     var value = ((this.value - this.min) / (this.max - this.min)) * 100;
//     this.style.background =
//         "linear-gradient(to right, #10d5c2 0%, #10d5c2 " +
//         value +
//         "%, #eaeefb " +
//         value +
//         "%, #eaeefb 100%)";
// };