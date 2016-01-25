$(document).ready(function(){
  var characters = 240;
  $("#message").keyup(function(){
    var remaining = characters -  $(this).val().length;
    $(".counter").html(remaining);
  });
});