$(document).ready(function () {
    $(".button-group .button input").on("click", function () {
        $(this).parent().siblings(".button.active").removeClass("active");
        $(this).parent().addClass("active");
        let target = $(this).data('rel');
        $("[name=" + target + "][value=" + $(this).val() + "]").parent().siblings(".button").show();
        $("[name=" + target + "][value=" + $(this).val() + "]").parent().hide();
    });
});