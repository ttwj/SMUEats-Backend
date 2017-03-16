var smuEats = new Framework7({
    modalTitle: 'SMOOeats',
    // Enable Material theme
    material: true,
    //pushState: true
});

var privatebrowsing = false;


if (typeof localStorage === 'object') {
    try {
        localStorage.setItem('localStorage', 1);
        localStorage.removeItem('localStorage');
    } catch (e) {
        Storage.prototype._setItem = Storage.prototype.setItem;
        Storage.prototype.setItem = function () {
        };
        privatebrowsing = true;
        alert('Your web browser does not support storing settings locally. In Safari, the most common cause of this is using "Private Browsing Mode". Some settings may not save or some features may not work properly for you.');
    }
}


smuEatsAddr = "http://smooeats.beepbeep.rocks"
beepbeepAddr = "http://beta.beepbeep.rocks"

//smuEatsAddr = "http://localhost:8000"
//beepbeepAddr = "http://localhost:3000"


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
    getWallet(false);

    //for some strange reason Dom7 doesn't want to work here o_O
    $('.login-button').click(function () {
        performLogin();
    });
    $('.preloader-button').click(function () {
        smuEats.showPreloader('Loading..');
    });

    $('.top-up-wallet-button').click(function (e) {
        show_qr_code();

    });


    $('.order-cancel-confirm-button').click(function () {
        smuEats.confirm('Are you sure you want to cancel your order!?',
            function () {
                $.ajax({
                    url: smuEatsAddr + "/frontend/order/checkout/cancel",
                    method: "GET",
                    success: function (data) {
                        smuEats.hidePreloader();
                        if (data.success == true) {
                            smuEats.alert("Your order has been cancelled :(", function () {
                                window.location.href = smuEatsAddr;
                            });

                        }
                        else if (data.success == false) {
                            smuEats.alert(data.error);
                        }
                        else {
                            smuEats.alert('An unexpected error occured :(');
                        }

                    },
                    error: function (err) {
                        smuEats.hidePreloader();
                        data = err.responseJSON;
                        console.log("error data" + data);

                        if (data.error != undefined) {
                            smuEats.alert(data.error);
                        }
                        else {
                            //wtf
                            smuEats.alert('An unexpected error occured :(');
                        }

                    }, statusCode: {
                        500: function () {
                            smuEats.hidePreloader();
                            smuEats.alert('An unexpected error occured :(');
                        }
                    }
                });

            }
        );
    });

    $('.deliver-completed-code').click(function () {

        smuEats.prompt('Enter Code', 'Order Confirmation',
            function (value) {

                if (!value || value.length != 5) {
                    smuEats.alert('Invalid token, please try again')
                    return;
                }

                $.ajax({
                    url: smuEatsAddr + "/frontend/deliver/complete",
                    method: "POST",
                    data: {
                        'token': value,
                    },

                    success: function (data) {
                        if (data.success == true) {
                            smuEats.alert("Your order has been completed! A confirmation SMS will be sent to you shortly", function () {
                                window.location.href = smuEatsAddr;
                            });
                        }
                        else {
                            smuEats.alert('An unexpected error occured :(');
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

                    },
                });

            }
        );
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
    if (privatebrowsing == true) {
        smuEats.alert('Please exit from private browsing mode or enable HTML5 localStorage in your browser, thanks!');
        return;
    }
    console.log('hi');
    // $('#login-form').submit();

    var username = $('#login-username').val();
    var password = $('#login-password').val();

    console.log($('#login-username'))

    if (!username || !password) {
        //Your username and password didn't match. Please try again.
        showError("Please enter your username/password")
    }
    else {
        console.log("doing ajax yo")
        $.ajax({
            url: beepbeepAddr + "/v1/account/session_auth",
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
                    smuEats.showPreloader('Logging in..');

                    $.ajax({
                        url: beepbeepAddr + "/v1/sso-token",
                        method: "GET",
                        xhrFields: {
                            withCredentials: true
                        },

                        success: function (data) {
                            if (data.token != undefined) {
                                console.log("sso token ok")
                                console.log(data);
                                localStorage.setItem("bb-sso-token", data.token);
                                window.location.href = smuEatsAddr + '/sso/'
                            }
                            else {
                                showError('Could not obtain API token :(');
                            }
                        },
                        error: function (err) {
                            data = err.responseJSON;
                            console.log(data);
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
                else {
                    showError('An unexpected error occured :(');
                }

            },
            error: function (err) {
                data = err.responseJSON;
                console.log(data);
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

var refresh_interval_id = -1;

smuEats.onPageAfterAnimation('deliver-index', function () {
    smuEats.hidePreloader();
    smuEats.hidePreloader();
    smuEats.hidePreloader();
});


smuEats.onPageBeforeAnimation('deliver-index', function () {
    console.log('setting up refresh');
    refresh_interval_id = setInterval(refreshPage, 18000);

    console.log("sso token " + localStorage.getItem("bb-sso-token"))


    function refreshPage() {
        console.log("refreshing page!");
        smuEats.showPreloader('Updating live orders..');
        $('#deliver-open-orders-wrapper').load(smuEatsAddr + "/frontend/deliver/ #deliver-open-orders", function (response, status, xhr) {
            console.log("response refresheds");
            smuEats.hidePreloader();
        });
    }
})

var primary_wallet_balance = 0.00;
var primary_wallet;

function getWallet(getHistory) {
    $.ajax({
        url: beepbeepAddr + "/v1/account/",
        method: "GET",
        xhrFields: {
            withCredentials: true
        },
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', 'Token ' + localStorage.getItem("bb-sso-token"));
        },
        success: function (data) {
            console.log("obtained wallet balance")
            primary_wallet = data[0];

            if (primary_wallet != undefined) {
                primary_wallet_balance = primary_wallet.balance;
                $$('.checkout-wallet-balance').html('$' + primary_wallet.balance)
                if (getHistory == true) {
                    getBankAccounts();
                    getWalletHistory(primary_wallet.id);
                }


            }

            else {
                //wtf
                smuEats.alert('An unexpected error occured :(');
                $('#register-init-button').show();
                $('.please-wait').hide();
            }
        },

    });
}

function getBankAccounts() {
    $.ajax({
        url: beepbeepAddr + "/v1/account/banks/",
        method: "GET",
        xhrFields: {
            withCredentials: true
        },
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', 'Token ' + localStorage.getItem("bb-sso-token"));
        },
        success: function (data) {
            if (data.count < 1) {
                smuEats.alert('Your wallet history is empty');
            }
            for (i in data) {
                acc = data[i];
                console.log(acc);
                $$('#bank-accounts-list').append('<li> <label class="label-radio item-content">' +
                    '<input id="wallet-payment-radio" type="radio" name="bank_account" checked="checked" value="' + acc.account_no + '">' +
                    '<div class="item-media"> <i class="icon icon-form-radio"></i> </div><div class="item-inner"> ' +
                    '<div class="item-title">' + acc.bank_sg + ' - ' + acc.account_no + '</small></i></span> </div></div></label> </li>');

            }
        },

    });
}


function getWalletHistory(account_id) {
    $.ajax({
        url: beepbeepAddr + "/v1/account/" + account_id + "/history/",
        method: "GET",
        xhrFields: {
            withCredentials: true
        },
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', 'Token ' + localStorage.getItem("bb-sso-token"));
        },
        success: function (data) {
            if (data.count < 1) {
                smuEats.alert('Your wallet history is empty');
            }
            for (i in data) {
                txn = data[i];
                console.log(txn);
                $$('#transactions-cards').append('<div class="card"> <a href="#" class="ripple menu-item-href"> ' +
                    '<div class="card-content"> <div class="card-content-inner"> ' +
                    '<div class="row"> <div class="col-10">' + txn.amount + '</div><div class="col-10">' + txn.source_name + '</div>' +
                    '<div class="col-10">' + txn.destination_name + '</div><div class="col-20">' + txn.description + '</div><div class="col-20">' + txn.date_created + '</div>' +
                    '</div></div></div></a> </div>');

            }
        },

    });

}

function show_qr_code() {
    var qrcode = new QRCode(document.getElementById("qrcode"), {
        text: localStorage.getItem("bb-sso-token"),
        width: 300,
        height: 300,
        colorDark: "#000000",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
    });
    smuEats.pickerModal('.picker-modal-qr-code');
}

smuEats.onPageAfterAnimation('checkout-view-cart', function (page) {
    //obtain wallet balance
    getWallet(false);


});

smuEats.onPageAfterAnimation('wallet', function (page) {
    console.log('checking wallet')
    //obtain wallet balance
    var qrcode = new QRCode(document.getElementById("qrcode-wallet"), {
        text: localStorage.getItem("bb-sso-token"),
        width: 250,
        height: 250,
        colorDark: "#000000",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
    });
    getWallet(true);


});

smuEats.onPageBeforeAnimation('*', function (page) {
    console.log("hello at page" + page.name)
    if (page.name != 'deliver-index' && refresh_interval_id != 1) {
        //we were previously @ deliver-index, stop the refresh
        console.log('clearing refresh');
        clearInterval(refresh_interval_id);
        refresh_interval_id = -1;
    }
});


smuEats.onPageBeforeRemove('deliver-index', function () {
    console.log('clearing refresh');
    clearInterval(refresh_interval_id);
    refresh_interval_id = -1;
})

smuEats.onPageInit('*', function (page) {
    $$('.preloader-button').on('click', function () {
        smuEats.showPreloader('Loading..');
    });

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
        $('.please-wait-verify').show();

        $.ajax({
            url: beepbeepAddr + "/v1/account/register/init",
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
            url: beepbeepAddr + "/v1/account/register/confirm",
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
                    $(this).hide();
                    $('.please-wait-register').show();
                    localStorage.setItem("bb-sso-token", data.token);
                    window.location.href = smuEatsAddr + "/sso/"
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
            url: beepbeepAddr + "/v1/account/register/verify",
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


    console.log("hi");

    Dom7('.menu-item-href-order').on('click', function (e) {


        $$('.cart-item-name').html($$(this).attr('item-name'));
        $$('#cart-item-remarks').html($$(this).attr('item-remarks'));
        $$('#cart-add-item').attr('item-id', $$(this).attr('item-id'));
        smuEats.pickerModal('.picker-modal-store');


    });

    Dom7('#cart-add-item').on('click', function (e) {
        var quantity = Number($$('#cart-item-quantity').val());

        if (!Number.isInteger(quantity) || quantity < 1) {
            quantity = 1;
        }
        $.post(smuEatsAddr + "/frontend/order/add_cart/",
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
                $$('#cart-item-notes').val('');
                $$('#cart-item-quantity').val('1');

            }).fail(function (data) {
            smuEats.closeModal('.picker-modal-store');
            smuEats.alert("Error: Could not add item to cart?!    :((((");
            $$('#cart-item-notes').val('');
            $$('#cart-item-quantity').val('1');

        });

    });


    Dom7('.top-up-wallet-button').on('click', function (e) {
        show_qr_code();

    });

    Dom7('.menu-item-href-checkout').on('click', function (e) {
        var item = $$(this);
        var item_id = $$(this).attr('cart-id');
        smuEats.confirm('Are you sure you want to delete this item?', function () {

            $.getJSON(smuEatsAddr + "/frontend/order/del_cart/" + item_id + "/", function (data) {
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
                $$('#checkout-total').attr('total', data.total);
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


    $$('.checkout-confirm-button').on('click', function () {


        //verification checks
        var total = $$('#checkout-total').attr('total');
        console.log(total);
        console.log(primary_wallet_balance);

        console.log(($('#wallet-payment-radio').is(":checked")))

        if (primary_wallet_balance == undefined) {
            smuEats.alert('Please wait, checking your wallet balance..');
            return
        }
        else if ((Number(total) > Number(primary_wallet_balance)) && ($('#wallet-payment-radio').is(":checked"))) {
            smuEats.alert('You do not have sufficient balance in your wallet! :(');
            return;
        }
        var location = $$('#location').val();
        if (!location) {
            smuEats.alert('Please enter a location!');
            return;
        }
        var time = $$('#checkout-deliver-minutes').val();
        if (!time) {
            smuEats.alert('Please enter a valid time!');
            return;
        }
        else if (time < 15) {
            smuEats.alert('Min. waiting time is 15 minutes');
            return;
        }


        var data = $("#checkout-form input").serializeArray();
        data.push({
            'name': 'location',
            'value': location,


        })
        data.push({
            'name': 'bb-sso-token',
            'value': localStorage.getItem("bb-sso-token")
        })

        console.log('data ')
        console.log(data)

        smuEats.showPreloader('Sending order..')

        $.ajax({
            url: smuEatsAddr + "/frontend/order/checkout/confirm",
            method: "POST",
            data: $.param(data),
            success: function (data) {
                smuEats.hidePreloader();
                if (data.success == true) {
                    smuEats.alert("Your order has been placed! You may cancel it before someone agrees to deliver it.", function () {
                        window.location.href = smuEatsAddr;
                    });

                }
                else {
                    smuEats.alert('An unexpected error occured :(');
                }

            },
            error: function (err) {
                smuEats.hidePreloader();
                data = err.responseJSON;
                console.log("error data" + data);

                if (data.error != undefined) {
                    smuEats.alert(data.error);
                }
                else {
                    //wtf
                    smuEats.alert('An unexpected error occured :(');
                }

            }, statusCode: {
                500: function () {
                    smuEats.hidePreloader();
                    smuEats.alert('An unexpected error occured :(');
                }
            }
        });

    });
    $$('.deliver-confirm-button').on('click', function () {

        var order_id = $('#checkout-total').attr('order-id');
        if (!order_id || order_id < 1) {
            smuEats.alert('An unexpected error occured!?! Could not find order ID :(');
        }
        $.ajax({
            url: smuEatsAddr + "/frontend/deliver/fulfil/" + order_id + "/",
            method: "POST",
            data: {
                'bb-sso-token': localStorage.getItem("bb-sso-token")
            },

            success: function (data) {
                if (data.success == true) {
                    smuEats.alert("You've accepted this order! A confirmation SMS will be sent to you shortly.", function () {
                        window.location.href = smuEatsAddr;
                    });
                }
                else {
                    smuEats.alert('An unexpected error occured :(');
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

            },
        });

    });
    $$('.wallet-perform-withdraw').on('click', function () {
        var withdraw_amount = $('#withdraw-amount').val();
        if (!withdraw_amount || withdraw_amount < 0.01) {
            smuEats.alert('Please enter a correct withdrawal amount, min. $0.01');
            return;

        }

        smuEats.confirm('Are you sure you want to perform the withdrawal?', function () {
            var data = $("#withdraw-form input").serializeArray();
            console.log("withdraw data");

            data.push({
                'name': 'account',
                'value': primary_wallet.id,


            });
            console.log(data);
            smuEats.showPreloader();

            $.ajax({
                url: beepbeepAddr + "/v1/transfer/withdraw/",
                method: "POST",
                data: $.param(data),
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('Authorization', 'Token ' + localStorage.getItem("bb-sso-token"));
                },
                success: function (data) {
                    smuEats.hidePreloader();
                    if (data.success == true) {
                        smuEats.alert("Your withdrawal is complete", function () {
                            window.location.href = smuEatsAddr;
                        });

                    }
                   else if (data.error != undefined) {
                        smuEats.alert(data.error);
                    }
                    else {
                        //wtf
                        smuEats.alert('An unexpected error occured :(');
                    }

                },
                error: function (err) {
                    smuEats.hidePreloader();
                    data = err.responseJSON;
                    console.log("error data" + data);

                    if (data.error != undefined) {
                        smuEats.alert(data.error);
                    }
                    else {
                        //wtf
                        smuEats.alert('An unexpected error occured :(');
                    }

                }, statusCode: {
                    500: function () {
                        smuEats.hidePreloader();
                        smuEats.alert('An unexpected error occured :(');
                    }
                }
            });


        });

    });


});