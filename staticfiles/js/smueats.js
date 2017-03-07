var smuEats = new Framework7({
	modalTitle: 'SMUEats',
	// Enable Material theme
	material: true,
	pushState: true
});

// Expose Internal DOM library
var $$ = Dom7;




// Add main view
var mainView = smuEats.addView('.view-main', {

});

function simulateClick(elements) {
	Dom7.each(elements, function(element) {
		element.mousedown();
	});
}

function triggerMouseEvent(node, eventType) {
	var clickEvent = document.createEvent('MouseEvents');
	clickEvent.initEvent(eventType, true, true);
	node.dispatchEvent(clickEvent);
}

function sleep(ms) {
	return new Promise(resolve => setTimeout(resolve, ms));
}

$$(document).on('pageInit', function() {

	Dom7('.menu-item-href-order').on('mousedown', function(e) {


		$$('#cart-item-name').html($$(this).attr('item-name'));
		$$('#cart-add-item').attr('item-id', $$(this).attr('item-id'));
		smuEats.pickerModal('.picker-modal-store');


	});

	Dom7('#cart-add-item').on('click', function(e) {
		$.getJSON("http://localhost:8000/frontend/order/add_cart/" + $$(this).attr('item-id'), function(data) {
			var e = Dom7('.checkout-total');
			$('.checkout-toolbar').removeClass('navbar-hidden');
			smuEats.closeModal('.picker-modal-store');
			e.html("Total: $" + data.total);
			$$('#checkout-total').html('Total: $' + data.total);
			setTimeout(function() {
				e.each(function() {
					triggerMouseEvent(this, "mousedown");
					sleep(2000);
					triggerMouseEvent(this, "mouseup");

				});
			}, 300);
		});
	});


	Dom7('.menu-item-href-checkout').on('click', function(e) {
		var item = $$(this);
		var item_id = $$(this).attr('item-id');
		smuEats.confirm('Are you sure you want to delete this item?', function() {
			console.log(item);
			$.getJSON("http://localhost:8000/frontend/order/del_cart/" + item_id, function(data) {
				/*var e = Dom7('#checkout-total')[0];
				triggerMouseEvent (e, "mousedown");
				sleep(200);
				triggerMouseEvent (e, "mouseup");

				This doesn't work for some reason o_O

				*/
				$$('#checkout-total').html('Total: $' + data.total);
				$$('.checkout-total').html('Total: $' + data.total);
			});
			item.hide();
		});
	});



});