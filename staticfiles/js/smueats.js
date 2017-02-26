
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

$$(document).on('pageInit', function() {

    Dom7('.menu-item-href').on('click', function (e){
        $.getJSON("http://localhost:8000/frontend/order/add_cart/" +  $$(this).attr('item-id'), function (data) {
            $('.checkout-toolbar').removeClass('navbar-hidden');
            Dom7('.checkout-total').html("Total: $" + data.total);
        });
    });


});
