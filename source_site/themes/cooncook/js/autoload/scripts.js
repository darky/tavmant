$(document).ready(function() {
	
	
	
	var windowWidth = $(window).width();
	
	

	 
	 
	    if (windowWidth <  1000 ) {
			
			
	/////////////////////////////////////
    //  Disable Mobile Animated
    /////////////////////////////////////
			
			
			$("body").removeClass("noIE");
			
			
		}
		



    /////////////////////////////////////
    //  HOVER GRID FIX
    /////////////////////////////////////


    $('ul.product_list  li').live('mouseover', function() {

        $(this).addClass("hovered");

    });

    $('ul.product_list  li').live('mouseleave', function() {
        $(this).removeClass("hovered");
    });





    /////////////////////////////////////
    //  HOVER ANIMATED
    /////////////////////////////////////
	
	

    $('.popover-shorty a').hover(
        function() {

            $('.popover.bottom').data('data-animation', "fadeInUp");
            $('.popover.bottom').addClass("animated");
            $('.popover.bottom').addClass("animation-done");
            $('.popover.bottom').addClass("fadeInUp");


        },
        function() {
            $('.popover.bottom').removeClass("animated");
            $('.popover.bottom').removeClass("animation-done");
            $('.popover.bottom').removeClass("fadeInUp");
        });

    $('.prevbg , .prevbg').hover(
        function() {

            $('#belvg_product_pager  img.hint').addClass("animated");
            $('#belvg_product_pager  img.hint').addClass("animation-done");
            $('#belvg_product_pager  img.hint').addClass("fadeInUp");


        },
        function() {
            $('#belvg_product_pager  img.hint').removeClass("animated");
            $('#belvg_product_pager  img.hint').removeClass("animation-done");
            $('#belvg_product_pager  img.hint').removeClass("fadeInUp");
        });




    /////////////////////////////////////
    //  Sticky Header
    /////////////////////////////////////


    if ($('body').length) {
        $(window).on('scroll', function() {
            var winH = $(window).scrollTop();
            var $pageHeader = $('.site-menu-mega');
            if (winH > 60) {
                $pageHeader.addClass('sticky');
            } else {
                $pageHeader.removeClass('sticky');
            }
        });
    }



    /////////////////////////////////////
    //  Home slider
    /////////////////////////////////////

    function sliderAutoHeight() {




        var windowHeight = $(window).height();
        var windowWidth = $(window).width();



        var slider = $("#index #iview");




        if (windowHeight > 450) {

            slider.css("max-height", windowHeight - 200);


        };




        $('.scroll_down').click(function(event) {
            event.preventDefault();

            $('html, body').animate({
                scrollTop: windowHeight - 100
            }, 300);
        });


    };


    sliderAutoHeight();


    $(window).resize(function() {
        sliderAutoHeight();
    });

    ////////////////////////////////////////////  
    // MOBILE MENU
    ///////////////////////////////////////////  




    $('.cat-title').click(function() {

        $(this).toggleClass("active");
        $(".menu-content").toggle();

    });


    $('.footer-container #footer h4').click(function() {


        $(this).next(".block_content").toggle();
        $(this).toggleClass("active");

    });




    ////////////////////////////////////////////  
    // FACEBOOK
    ///////////////////////////////////////////  

    $('.facebook-fixed .fbbutton').click(function() {

        $('.facebook-fixed').toggleClass("fbopen");


    });




    ////////////////////////////////////////////  
    // CAROUSEL
    /////////////////////////////////////////// 


    function CarouselSet() {


  
        var WidthWindow = $("body").width();



        if (WidthWindow > 1200) {



            $('.wrap-brand ul').bxSlider({
                adaptiveHeightSpeed: false,
                adaptiveHeight: false,
                minSlides: 6,
                maxSlides: 6,
                slideWidth: 195,
                slideMargin: 15,
                auto: true,
                nextText: '',
                prevText: ''
            });



            var productsCategorylength = $('#productscategory_list ul li').length;


            if (productsCategorylength > 4) {

                $('#productscategory_list ul ').bxSlider({
                    slideWidth: 275,
					auto:true,
                    minSlides: 4,
                    maxSlides: 4,
                    slideMargin: 25,
                    nextText: '',
                    prevText: ''
                });

            }



            $('.bxslider-custom').bxSlider({
                slideWidth: 355,
                minSlides: 4,
                maxSlides: 4,
                slideMargin: 15,
                moveSlides: 2,
                nextText: '',
                prevText: ''
            });




         

        } else {

            if (WidthWindow > 600) {




                $('.wrap-brand ul').bxSlider({
                    adaptiveHeightSpeed: false,
                    adaptiveHeight: false,
                    minSlides: 5,
                    maxSlides: 5,
                    slideWidth: 195,
                    slideMargin: 15,
                    auto: true,
                    nextText: '',
                    prevText: ''
                });


               
				
				
				   $('#productscategory_list ul ').bxSlider({
                    slideWidth: 315,
					auto:true,
                    minSlides: 3,
                    maxSlides: 3,
                    slideMargin: 35,
                    nextText: '',
                    prevText: ''
                });




                $('.bxslider-custom').bxSlider({
                    slideWidth: 355,
                    minSlides: 3,
                    maxSlides: 3,
                    slideMargin: 15,
                    moveSlides: 2,
                    nextText: '',
                    prevText: ''
                });





            } else {




                $('.wrap-brand ul').bxSlider({
                    adaptiveHeightSpeed: false,
                    adaptiveHeight: false,
                    minSlides: 1,
                    maxSlides: 1,
                    slideWidth: 195,
                    slideMargin: 15,
                    auto: true,
                    nextText: '',
                    prevText: ''
                });



           $('#productscategory_list ul ').bxSlider({
                    slideWidth: 275,
					auto:true,
                    minSlides: 1,
                    maxSlides: 1,
                    slideMargin: 25,
                    nextText: '',
                    prevText: ''
                });


                $('.bxslider-custom').bxSlider({
                    slideWidth: 355,
                    minSlides: 1,
                    maxSlides: 1,
                    slideMargin: 15,
                    moveSlides: 2,
                    nextText: '',
                    prevText: ''
                });






            }


        }

    };


    CarouselSet();

    /*   
    $(window).resize(function(){
    						  
       CarouselSet();
    });
      */
	  
	  

    $('.bx-next').html(' <i class="fa icon-angle-right"></i>')
    $('.bx-prev').html(' <i class="fa icon-angle-left"></i>')

  $('.iview-prevNav').html(' <i class="fa icon-angle-right"></i>')
    $('.iview-nextNav').html(' <i class="fa icon-angle-left"></i>')


    ////////////////////////////////////////////  
    // PRODUCT TABS
    ///////////////////////////////////////////  


    $('.page-product-box h3').click(function() {


        $(this).parent().toggleClass('open-tab-item');



    });




    ////////////////////////////////////////////  
    // MEGA MENU
    ///////////////////////////////////////////  


    // add class submenu to submenu's that are not megamenu
    $('.main-menu ul').each(function() {
        if ($(this).closest('.mega-menu').length == 0) {
            $(this).addClass('sub-menu');
        }
    });
    // add class has-child to each menu item that has child
    $('.main-menu li').each(function() {
        if ($(this).find('ul').length)
            $(this).addClass('has-child');
    });

    $('.main-menu li').hoverIntent({
        // on menu mouse hover function handler
        over: function() {
            var $this = $(this),
                $mm = $this.children('.mega-menu'),
                $parent = $this.closest('.inner');

            // we need to setup megamenu position and width
            $mm.css({
                'left': ($parent.offset().left - $this.offset().left - 1) + 'px',
                'width': $parent.outerWidth() - 60,
                'visibility': 'visible'
            });

            // now we are good and we can show the megamenu
            $this.addClass('active').children('ul, .mega-menu').animate({
                'height': 'toggle'
            }, 300, function() {
                $(this).css('overflow', 'visible');
            });
        },
        // mouse out handler
        out: function() {
            $(this).removeClass('active').children('ul, .mega-menu').animate({
                'height': 'toggle'
            }, 200, function() {
                $(this).css('overflow', 'visible');
            });
        },
        // A simple delay, in milliseconds, before the "out" function is called
        timeout: 200
    });


    ////////////////////////////////////////////  
    // FOOTER
    /////////////////////////////////////////// 


    $('.footer-container #footer h4').click(function() {


        $(this).parent().toggleClass('open-foot');



    });
	
	
	$('.price table tr:odd td').css('background','#1f4b92');
	
	
	
	
	
	/*HOME BOX ADD LINKS*/

 
 


var hrefLinks1 = $('.box.hg_510.box_1.red5 figure a').attr("href") ;
	
	
	$('.box.hg_510.box_1.red5 figure figcaption').click(function(){
		
		$(location).attr('href',hrefLinks1);
		
		});
		
		
		


	var hrefLinks2 = $('.box.hg_510.box_2.red5 figure a').attr("href") ;
	
	
	$('.box.hg_510.box_2.red5 figure figcaption').click(function(){
		
		$(location).attr('href',hrefLinks2);
		
		});


 
 
 
			var hrefLinks3 = $('.box.hg_310.box_1.red5 figure a').attr("href") ;
	
	
	$('.box.hg_310.box_1.red5  figcaption').click(function(){
		
		$(location).attr('href',hrefLinks3);
		
		})
		


					var hrefLinks4 = $('.box.hg_310.box_2.red5 figure a').attr("href") ;
	
	
	$('.box.hg_310.box_2.red5 figure figcaption').click(function(){
		
		$(location).attr('href',hrefLinks4);
		
		})	
	
	
	
		var hrefLinks5 = $('.box.hg_310.box_3.red5 figure a').attr("href") ;
	
	
	$('.box.hg_310.box_3.red5 figure figcaption').click(function(){
		
		$(location).attr('href',hrefLinks5);
		
		})	
	
	
	
	




});