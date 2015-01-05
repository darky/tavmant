/**
 * 2007-2013 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 *         DISCLAIMER   *
 * *************************************** */
 /* Do not edit or add to this file if you wish to upgrade Prestashop to newer
 * versions in the future.
 * ****************************************************
 *
 *  @author     BEST-KIT.COM (contact@best-kit.com)
 *  @copyright  http://best-kit.com
 *  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *  International Registered Trademark & Property of PrestaShop SA
 */

(function($){
	$(document).ready(function(){
		var count = 0;
		$('section.page-product-box').each(function(){
			if ($(this).children().length > 0) {
				count++;
				var title = $(this).find('.page-product-heading').text();
				var content;
				if ($(this).find('a.page-product-heading').length > 0) {
					content = $($(this).find('.page-product-heading').attr('href')).html();
				} else {
					content = $('<div>').append($(this).find('h3').next()).html();
				}
				
				
				var con = $('#bestkit_bootstraptabs');
				if (con.attr('data-type') == 'accordion' || con.attr('data-type') == 'two_cols_accordion') {
					con.find('.bs-example').append('\
					<div class="panel panel-default'+(con.attr('data-type') == 'two_cols_accordion' ? ' center-column col-xs-6 col-sm-6' : '')+'">\
						<div class="panel-heading">\
							<h4 class="panel-title">\
								<a href="#TabBoot'+count+'" data-parent="#accordion" data-toggle="collapse" class="collapsed">'+title+'</a>\
							</h4>\
						</div>\
						<div class="panel-collapse collapse"  id="TabBoot'+count+'" >\
							<div class="panel-body">'+
								content+'\
							</div>\
						</div>\
					</div>\
					');
	
					if (count == 1) {
						con.find('.panel-title a:first').click();
					}
				} else {
					con.find('ul.nav-tabs').append('<li class="'+(count==1?'active':'')+'"><a href="#TabBoot'+count+'">'+title+'</a></li>');
					con.find('.tab-content').append('<div class="tab-pane fade'+(count==1?' active in':'')+'" id="TabBoot'+count+'">'+
					content+'</div>');
				}
			}
		});

		$('ul.nav-tabs a').click(function(){
			$(this).tab('show');
			return false;
		});

		$('section.page-product-box').hide();
	});
})(jQuery);