$(document).ready(function () {
	
	var hOne;
	var hTwo;
	var mOne;
	var mTwo;
	var sOne;
	var sTwo;
	var now;
	var sek;
	var minut;
	var hour;
	
	function rotate (elOne, elTwo, time) {
		if(elOne.css('display') == 'none'){
			elOne.css('z-index', '10').text(time);
			elTwo.css('z-index', '0');
			elOne.slideDown(500, function(){
					elTwo.hide();
							});
						}
						
		if(elTwo.css('display') == 'none'){
			elTwo.css('z-index', '10').text(time);
			elOne.css('z-index', '0');
			elTwo.slideDown(500, function(){
					elOne.hide();
							});			
						}
		}
		
	function scrol(){
			now = new Date();
			sek = now.getSeconds();
			
			rotate(sOne, sTwo, sek);
			if (minut != now.getMinutes()){
				minut = now.getMinutes();
				rotate(mOne, mTwo, minut);
				}
			if(hour != now.getHours()){
				hour = now.getHours();
				rotate(hOne, hTwo, hour);
				}
			setTimeout(scrol, 1000);
				}
	
	$(document).ready(function() {
		hOne = $("#hOne");
		hTwo = $("#hTwo");
		mOne = $("#mOne");
		mTwo = $("#mTwo");
		sOne = $("#sOne");
		sTwo = $("#sTwo");
			
			sOne.hide();
			mOne.hide();
			hOne.hide();	
			scrol();
		});	

 $('.shorty.horizontal  .shorty-slider').bxSlider();
 
 
 $('.shorty.verticale .shorty-slider').bxSlider({
  mode: 'vertical',
  slideMargin: 5
});





 

   $('.shorty .nav-tabs a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

	
	/*Portfolio*/
	
	
	  $(".view-icon").fancybox();


													
$(".hover_img").each(function (i) {
 

var PortfolioUrl  = $(this).children('img').attr('src');


 var PortfolioHref = $(this).children().children('.view-icon');
 
 
 PortfolioHref.attr('href',PortfolioUrl);
 


}); 

 if ($('.player').length > 0) {

 
 $(".player").mb_YTPlayer();
 
 
 }
 
 

});