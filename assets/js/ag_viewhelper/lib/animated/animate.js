$(document).ready(function () {
							
							
							
	 /////////////////////////////////////
    //  animate elements when they are in viewport
   /////////////////////////////////////
   


   $('.animated').waypoint(function () {
        var animation = $(this).data('animation');
        $(this).addClass('animation-done').addClass(animation);
    }, {
        triggerOnce: true,
        offset: '60%'
    });
   
   
   
	




});