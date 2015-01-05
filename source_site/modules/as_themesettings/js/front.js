/*(function($){


	$(document).ready(function(){
		if ($('.pagination_mobile').length) {
			$('div.pagination_mobile').hide();
			$('#category-list').after($('#more-products').html());
			if (!$('#layered_block_left').length) {
				if ($('.pagination_next').length && !$('.pagination_next').hasClass('disabled')) {
					$('.more-products .more-link').show();
				} else {
					$('.more-products .more-link').hide();
				}

				var link = $('.pagination_next a').attr('href');
				$('.more-products .more-link').live('click', function(){
					$('#category-list').css('opacity', '0.5');
					$.ajax({
						url: link,
						success: function(html){
							var products = html.split('ul id="category-list">')[1];
							products = products.split('</ul>')[0];
							$('#category-list').append(products);
							if (html.indexOf('pagination_next') > -1) {
								var pager = '<li class="new_pagination_next" id="new_pagination_next" ' + html.split('pagination_next')[1];
								pager = pager.split('</li>')[0] + '</li>';
								$('#dy_hider .pre-contant').html(pager);
								if ($('#new_pagination_next a').hasClass('disabled')) {
									$('.more-products .more-link').hide();
								} else {
									link = $('#new_pagination_next a').attr('href');
								}
							}
							
							$('#category-list').css('opacity', '1');
							if (typeof(ajaxCart) != "undefined") {
								ajaxCart.overrideButtonsInThePage();
							}
							
							if (typeof(reloadProductComparison) == 'function') {
								reloadProductComparison();
							}
						}
					});
				});
			} else {
				$('.more-products .more-link').live('click', function(){
					if (!$('#pagination_next').hasClass('disabled')) {
						$('#pagination_next a').click();
					}
				});
			}
		}
	});
})(jQuery);*/