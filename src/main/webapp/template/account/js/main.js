(function($) {

    "use strict";

    // Xử lý hiệu ứng khi bấm vào ô nhập liệu
    $(".form-group input").on("focus", function(){
        $(this).parent().addClass("focus");
    });

    // Xử lý khi chuột rời khỏi ô nhập liệu
    $(".form-group input").on("blur", function(){
        if($(this).val() == "")
            $(this).parent().removeClass("focus");
    });

    // Code chặn gửi form nếu để trống (Validation)
    $('#login-form').on('submit', function(e){
        var username = $('#username').val();
        var password = $('#password').val();

        if(username.trim() == "" || password.trim() == "") {
            e.preventDefault();
            alert("Vui lòng điền đầy đủ thông tin!");
        }
    });

})(jQuery);