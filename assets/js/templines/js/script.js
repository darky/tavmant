




$(document).ready(function(){
						   
						   
 ////////////////////////////////////////////  
    //  Animate the scroll to top
    ///////////////////////////////////////////  

		
$(function(){
   $('#mp-menu a[href^="#"]').click(function(){
        var target = $(this).attr('href');
        $('html, body').animate({scrollTop: $(target).offset().top}, 700);
        return false; 
   }); 
});
	

						   
						   
						   
	
$( '.color_scheme_item li' ).click(function(){
											
											
					
						$( '.color_scheme_item li' ).removeClass('active');
							$(this).addClass('active');
						
											
											});


	$( '#trigger' ).click( function(){
		
		
	$( '#themeConfigForm').toggleClass('open-menu');
		
		});
		
		
			$( '.mp-menu h3' ).parent().click( function(){
		
		

	
	$(this).next("ul").toggle();

		
		});
		
		
		
	


});


	

  
