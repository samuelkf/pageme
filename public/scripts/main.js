$(document).ready(function(){
  var characters = 240;
  $(".message_text").keyup(function(){
    var remaining = characters -  $(this).val().length;
    $(".counter").html(remaining);
  });

  $(function() {
  $("form.message").submit(function(e){
    e.preventDefault();

    $(this).hide();

    $.ajax({
      type: $(this).attr("method"),
      url: $(this).attr("action"),
      data: $('form.register').serialize(),
      success: function(){
        $(".form_container").append("<p>message sent</p>")
      },
      error: function(){
        $(".form_container").append("<p>failed</p>")
      }
    });
  });
});
});