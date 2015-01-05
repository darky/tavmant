$(window).scroll(function(e){
  parallax();
});
function parallax(){
  var scrolled = $(window).scrollTop();
  $('.bg').css('background-position',-(scrolled*0.1)+'px');
}