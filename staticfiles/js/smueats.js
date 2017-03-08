var smuEats = new Framework7({
	modalTitle: 'SMUEats',
	// Enable Material theme
	material: true,
	pushState: true
});


var isAndroid = Framework7.prototype.device.android === true;
var isIos = Framework7.prototype.device.ios === true;

Template7.global = {
    android: isAndroid,
    ios: isIos
};

// Expose Internal DOM library
var $$ = Dom7;




// Add main view
var mainView = smuEats.addView('.view-main', {
      dynamicNavbar: true

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


$(document).ready(function() {

    //for some strange reason Dom7 doesn't want to work here o_O
    $('.login-button').click(function() {
        $('#login-form').submit();
    });



})


// using jQuery
function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie != '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
var csrftoken = getCookie('csrftoken');
function csrfSafeMethod(method) {
    // these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}
$.ajaxSetup({
    beforeSend: function(xhr, settings) {
        if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
        }
    }
});

$$(document).on('pageInit', function() {

    $$('.login-button').on('click', function() {
        console.log('hi');
        $('#login-form').submit();
    });

    $$('.checkout-confirm-button').on('click', function() {
        var location = $$('#location').val();
        if (!location) {
            smuEats.alert('Please enter a location!');
            return;
        }
        $$('#checkout-form').submit();
    });



    console.log("hi");

	Dom7('.menu-item-href-order').on('click', function(e) {


		$$('#cart-item-name').html($$(this).attr('item-name'));
		$$('#cart-add-item').attr('item-id', $$(this).attr('item-id'));
		smuEats.pickerModal('.picker-modal-store');


	});

	Dom7('#cart-add-item').on('click', function(e) {
		var quantity = Number($$('#cart-item-quantity').val());
		if (!Number.isInteger(quantity) || quantity < 1) {
			quantity = 1;
		}
		$.post("http://localhost:8000/frontend/order/add_cart/",
			{
				'quantity': quantity,
				'notes': $$('#cart-item-notes').val(),
				'item_id': $$(this).attr('item-id'),

			}, function(data) {

			if (data.total == undefined) {
				//ugh oh error
				smuEats.alert("Error: Could not add item to cart?!    :((((");
				return;
			}
			var e = Dom7('.checkout-total');
			$('.checkout-toolbar').removeClass('navbar-hidden');
			smuEats.closeModal('.picker-modal-store')
			setTimeout(function() {
				e.html("Total: $" + data.total);
				$$('#checkout-total').html('Total: $' + data.total);
				e.each(function() {
					triggerMouseEvent(this, "mousedown");
					sleep(1000);
					triggerMouseEvent(this, "mouseup");

				});
			}, 100);

		}).fail(function() {
			smuEats.closeModal('.picker-modal-store');
			smuEats.alert("Error: Could not add item to cart?!    :((((");

		});
        $$('#cart-item-notes').val('');
        $$('#cart-item-quantity').val('1');
	});



	Dom7('.menu-item-href-checkout').on('click', function(e) {
		var item = $$(this);
		var item_id = $$(this).attr('cart-id');
		smuEats.confirm('Are you sure you want to delete this item?', function() {

			$.getJSON("http://localhost:8000/frontend/order/del_cart/" + item_id, function(data) {
				if (data.total == undefined) {
				//ugh oh error
				smuEats.alert("Error: Could not delete item from cart?!    :((((");
				return;
			}
			else if (Number(data.total) == 0) {
				    //uh nothing here
                    mainView.router.back();
                    smuEats.alert("Your cart is empty!");
                }
				/*var e = Dom7('#checkout-total')[0];
				triggerMouseEvent (e, "mousedown");
				sleep(200);
				triggerMouseEvent (e, "mouseup");

				This doesn't work for some reason o_O

				*/

				$$('#checkout-total').html('Total: $' + data.total);
				$$('.checkout-total').html('Total: $' + data.total);
				item.hide();
			}).fail(function() {
			if (data.total == undefined) {
				//ugh oh error
				smuEats.alert("Error: Could not add item to cart?!    :((((");
				return;
			}
		});

		});
	});



});