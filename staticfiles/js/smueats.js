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
    Dom7.each(elements, function (element) {
        element.mousedown();
    });
}

function triggerMouseEvent(node, eventType) {
    var clickEvent = document.createEvent('MouseEvents');
    clickEvent.initEvent(eventType, true, true);
    node.dispatchEvent(clickEvent);
}

function sleep(ms) {
    //return new Promise(resolve => setTimeout(resolve, ms));
}


$(document).ready(function () {

    //for some strange reason Dom7 doesn't want to work here o_O
    $('.login-button').click(function () {
        performLogin();
    });


})


function showError(error) {
    $('#login-error').html(error);
    $('#login-error').show();
}

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
    beforeSend: function (xhr, settings) {
        if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
        }
    }
});

function performLogin() {
    console.log('hi');
    // $('#login-form').submit();

    var username = $('#login-username').val();
    var password = $('#login-password').val();

    if (!username || !password) {
        //Your username and password didn't match. Please try again.
        showError("Please enter your username/password")
    }
    else {
        $.ajax({
            url: "http://localhost:3000/v1/account/session_auth",
            method: "POST",
            xhrFields: {
                withCredentials: true
            },
            data: {
                'username': username,
                'password': password,
            },
            success: function (data) {

                if (data.success == true) {
                    //logged in, now redirect to SSO
                    window.location.href = 'http://localhost:8000/sso/'
                }
                else {
                    showError('An unexpected error occured :(');
                }

            },
            error: function (data) {
                if (data.error != undefined) {
                    showError(data.error);
                }
                else {
                    //wtf
                    showError('An unexpected error occured :(');
                }


            }
        });
    }
}

$$(document).on('pageInit', function () {

    /*registration*/

    $$('#register-init-button').on('click', function () {

        $$('.register-steps-tab').removeClass('active');
        $$('#register-steps-tab-2').addClass('active');
        var phone_number = $('#register-phone').val();
        if (!phone_number || phone_number.length != 8) {
            smuEats.alert("Please enter a valid Singapore phone number!");
            return;
        }
        console.log('clicked');
        $(this).hide();
        $('.please-wait').show();

        $.ajax({
            url: "http://localhost:3000/v1/account/register/init",
            method: "POST",
            xhrFields: {
                withCredentials: true
            },
            data: {
                'number': phone_number
            },
            success: function (data) {
                console.log('hello');
                console.log(data);
                 smuEats.showTab('#registration-2');
                if (data.success == true) {
                    smuEats.showTab('#registration-2');
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                    $('#register-init-button').show();
                    $('.please-wait').hide();
                }
            },
            error: function (err) {
                data = err.responseJSON;
                console.log("error data" + data);

                if (data.error != undefined) {
                    smuEats.alert(data.error);
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }
                if (data.show_verify == true) {
                    smuEats.showTab('#registration-2');
                    return;
                }
                $('#register-init-button').show();
                $('.please-wait').hide();

            },
        });

    });

    $$('#register-confirm-button').on('click', function () {
        var username = $('#register-username').val();
        var password = $('#register-password').val();

        if (!username || !password) {
            //Your username and password didn't match. Please try again.
            smuEats.alert("Please enter your username/password")
        }


        $.ajax({
            url: "http://localhost:3000/v1/account/register/confirm",
            method: "POST",
            xhrFields: {
                withCredentials: true
            },
            data: {
                'username': username,
                'password': password
            },
            success: function (data) {
                if (data.success == true) {
                    window.location.href = "http://localhost:8000/sso/"
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }
            },
            error: function (err) {
                data = err.responseText;
                if (data != undefined) {
                    smuEats.alert(data);
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }
            },
        });


    });

    $$('#register-verify-button').on('click', function () {
        $$('.register-steps-tab').removeClass('active');
        $$('#register-steps-tab-3').addClass('active');

        var token = $('#register-token').val();
        if (!token || token.length != 5) {
            smuEats.alert("Please enter a valid token!");
            return;
        }

        $.ajax({
            url: "http://localhost:3000/v1/account/register/verify",
            method: "POST",
            xhrFields: {
                withCredentials: true
            },
            data: {
                'token': token,
            },
            success: function (data) {
                if (data.success == true) {
                    smuEats.showTab('#registration-3');
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }
            },
            error: function (err) {
                data = err.responseJSON;
                console.log(data);
                if (data.error != undefined) {
                    smuEats.alert(data.error);
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }
            },
        });

    });

    $$('.login-button').on('click', function () {
        performLogin();
    });


    $$('.checkout-confirm-button').on('click', function () {
        var location = $$('#location').val();
        if (!location) {
            smuEats.alert('Please enter a location!');
            return;
        }
        $$('#checkout-form').submit();
    });


    console.log("hi");

    Dom7('.menu-item-href-order').on('click', function (e) {


        $$('#cart-item-name').html($$(this).attr('item-name'));
        $$('#cart-add-item').attr('item-id', $$(this).attr('item-id'));
        smuEats.pickerModal('.picker-modal-store');


    });

    Dom7('#cart-add-item').on('click', function (e) {
        var quantity = Number($$('#cart-item-quantity').val());
        if (!Number.isInteger(quantity) || quantity < 1) {
            quantity = 1;
        }
        $.post("http://localhost:8000/frontend/order/add_cart/",
            {
                'quantity': quantity,
                'notes': $$('#cart-item-notes').val(),
                'item_id': $$(this).attr('item-id'),

            }, function (data) {

                if (data.total == undefined) {
                    //ugh oh error
                    smuEats.alert("Error: Could not add item to cart?!    :((((");
                    return;
                }
                var e = Dom7('.checkout-total');
                $('.checkout-toolbar').removeClass('navbar-hidden');
                smuEats.closeModal('.picker-modal-store')
                setTimeout(function () {
                    e.html("Total: $" + data.total);
                    $$('#checkout-total').html('Total: $' + data.total);
                    e.each(function () {
                        triggerMouseEvent(this, "mousedown");
                        sleep(1000);
                        triggerMouseEvent(this, "mouseup");

                    });
                }, 100);

            }).fail(function (data) {
            smuEats.closeModal('.picker-modal-store');
            smuEats.alert("Error: Could not add item to cart?!    :((((");

        });
        $$('#cart-item-notes').val('');
        $$('#cart-item-quantity').val('1');
    });


    Dom7('.menu-item-href-checkout').on('click', function (e) {
        var item = $$(this);
        var item_id = $$(this).attr('cart-id');
        smuEats.confirm('Are you sure you want to delete this item?', function () {

            $.getJSON("http://localhost:8000/frontend/order/del_cart/" + item_id + "/", function (data) {
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
            }).fail(function (data) {
                if (data.total == undefined) {
                    //ugh oh error
                    smuEats.alert("Error: Could not add item to cart?!    :((((");
                    return;
                }
            });

        });
    });


});