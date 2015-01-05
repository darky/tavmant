




function initConfigurator(base_url){
	initColorPicker();
	initAjaxUploader(base_url);
	$('#openConfigurator').click(function(){
		openConfigWindow();
	});
	initExpander();
	$(document).ready(function(){
		fillDefaultPickers();
		$('#save_theme_config').click(function(){
			$.ajax({
				type: "POST",
				url: base_url + "index.php?module=templines&action=saveTC&fc=module&controller=dss&ajax=1",
				data: $('#themeConfigForm').serialize()
			}).done(function( msg ) {
			   location.reload();
			});
		});
		
		$('.color_scheme_item li a').click(function(){
			var selectedScheme = $(this).attr("id");
			$('#schemer_scheme').val(selectedScheme);
			for (var i = 1; i <= 6 ; i++){
				$('#style_scheme' + i ).attr("disabled", "disabled");
			}
			$('#style_' + selectedScheme ).removeAttr("disabled");
			$.ajax({
				type: "GET",
				url: base_url + "index.php?module=templines&action=getCssAjax&fc=module&controller=dss&ajax=1&css_file_name=" + selectedScheme,
			}).done(function(msg){
				$('#css_scheme_content').html("<style>" + msg + "</style>");
			});
			
		});
		
		$('.btn-save').click(function(){
			var type = $(this).attr("conftype");
			$.ajax({
				type: "POST",
				url: base_url + "index.php?module=templines&action=saveTC&fc=module&controller=dss&ajax=1&conftype="+type,
				data: $('#themeConfigForm').serialize()
			}).done(function( msg ) {
			   location.reload();
			});
		});
		$('#reset_cookie').click(function(){
			$.ajax({
				type: "POST",
				url: base_url + "index.php?module=templines&action=reset&fc=module&controller=dss&ajax=1",
				data: $('#themeConfigForm').serialize()
			}).done(function( msg ) {
			   location.reload();
			});
		});
		$('input.color-used').each(function(){
			$(this).attr("base-bg",$(this).prev().prev().css('background-color'));
		});
		$('input.color-used').click(function(){
			
			var classUsed = $(this).prev().prev().attr("id");
			classUsedRm = classUsed.replace('cs-','');
			
			if (!$(this).is(':checked')){
				$("." + classUsedRm).css('background-color',$(this).attr("base-bg"));
				$(this).prev().val($(this).attr("base-bg"));
			}else{
				$(this).attr("base-bg",$("." + classUsedRm).css('background-color'));
				$("." + classUsedRm).css('background', 'transparent');	
				$(this).prev().val('transparent');			
			}
			

			
		});
		$('.box-color .box-wrap').hide();
	});
	initFontSelector();
	initBgSelector();
	
}

function openConfigWindow(){
	$('#configuratorWindow').toggle();
	
}

function initColorPicker(){
	var styleDiv = "backgroundColor";
	

	$('.colorSelector').each(function(){
		var currentPickerDiv = $(this);
		if ($(currentPickerDiv).attr('data-type') == 'text')
			styleDiv = "text-color";
		
		var currentPickerDivColor = '#0000ff';
		$(this).ColorPicker({
			color: currentPickerDivColor,
			onShow: function (colpkr) {
				$(colpkr).fadeIn(500);
				return false;
			},
			onHide: function (colpkr) {
				$(colpkr).fadeOut(500);
				return false;
			},
			onChange: function (hsb, hex, rgb) {
				$(currentPickerDiv).css('backgroundColor', '#' + hex);
				
				switch($(currentPickerDiv).attr('data-type')){
					case 'text': $('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('color', '#' + hex); break;
					case 'border': $('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('border-color', '#' + hex); break;
					case 'hover':
						$('.' + $(currentPickerDiv).attr('id').replace('cs-','').replace(":hover","")).hover(function(){
		                    $('.' + $(currentPickerDiv).attr('id').replace('cs-','').replace(":hover","")).css("color", '#' + hex);
		                });
					break;
					default: $('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('background-color', '#' + hex); break;					
				}
				/*if ($(currentPickerDiv).attr('data-type') == 'text')
					$('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('color', '#' + hex);
				else
					$('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('background', '#' + hex);*/
				$(currentPickerDiv).next().val('#' +hex);		
			}
		});
	});

}

function initAjaxUploader(base_url){
	var uploader = $('#backgrUploader').ajaxUpload({
		url : base_url + "index.php",
		name: "file",
		onSubmit: function() {
		    $('#InfoBox').html('Uploading ... ');
		},
		onComplete: function(result) {
		    $('#InfoBox').html('File uploaded with result');
		}
	});
}

function initExpander(){
	$('.bg_controller .bg_block').each(function(){
		$(this).children(".bg-label").click(function(){	
			$(this).toggleClass("closed");
			$(this).next().toggle();
		});
	});
	$('.box-color h3').click(function(){
		$(this).next().toggle();
	});
}


$.fn.getStyleObject = function(){
    var dom = this.get(0);
    var style;
    var returns = {};
    if(window.getComputedStyle){
        var camelize = function(a,b){
            return b.toUpperCase();
        }
        style = window.getComputedStyle(dom, null);
        for(var i = 0, l = style.length; i < l; i++){
            var prop = style[i];
            var camel = prop.replace(/\-([a-z])/, camelize);
            var val = style.getPropertyValue(prop);
            returns[camel] = val;
        }
        return returns;
    }
    if(dom.currentStyle){
        style = dom.currentStyle;
        for(var prop in style){
            returns[prop] = style[prop];
        }
        return returns;
    }
    if(style = dom.style){
        for(var prop in style){
            if(typeof style[prop] != 'function'){
                returns[prop] = style[prop];
            }
        }
        return returns;
    }
    return returns;
}

function fillDefaultPickers(){
	$('.colorSelector').each(function(){
		var currentPickerDiv = $(this);
		if ($(currentPickerDiv).attr('data-type') == 'text')
			styleDiv = "text-color";
		var currentPickerDivColor = '#0000ff';
		if ($('.' + $(currentPickerDiv).attr('id').replace('cs-',''))){
			var currentClassSelect = "."+$(currentPickerDiv).attr('id').replace('cs-','');	
						
			if ($(currentPickerDiv).attr('data-type') == 'text')
					currentPickerDivColor = $('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('color');
				else{
					if ($(currentPickerDiv).attr('data-type') == 'hover'){
						currentClassSelect = currentClassSelect.replace(":hover","");
						$(currentClassSelect).hover( function() {
						    //get the colour of the hovered element while it is being hovered
						    var hoverName = currentPickerDiv.next().attr("name");
						    if (hoverName.indexOf("-link-"))
							    currentPickerDivColor = $(this).css("color");
							else
								currentPickerDivColor = $(this).css("backgroundColor");    
						    
						}, function(){});
						$(currentClassSelect).trigger('mouseenter');
					}
					else
						currentPickerDivColor = $('.' + $(currentPickerDiv).attr('id').replace('cs-','')).css('backgroundColor');
				}
					
			
			
		}
		
		
		
		currentPickerDiv.css("backgroundColor",currentPickerDivColor)
		currentPickerDiv.next().val(currentPickerDivColor);
	});	
}

function selectBg(bg){
	$('.bg-bg li').removeClass("active");
	$(bg).parent().addClass("active");
	$('body').css("background","url('"+$(bg).attr("src")+"')");
	$("#main_bg_value").val($(bg).attr("src"));
	
}

function initFontSelector(){
	$('#headingfont').change(function(){
		$('body').css("font-family",$('#headingfont').val());
	});
}

function initBgSelector(){
	var currentBg = $('body').css("background-image");
	
	if ($('#backgrounds li').size() > 1){
		$('#backgrounds li').each(function(){
			currentBg = unescape(currentBg);		
			if (currentBg == "url("+$(this).find("img").attr("src")+")"){
				$(this).addClass('active');
				
			}
		});
	}
	$("#main_bg_value").val(currentBg);
}


