// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.lazyload
//= require i18n/translations
//= require bootstrap-sprockets
//= require get-ipinfo
//= require jquery.tmpl.min
//= require jquery.easing.1.3
//= require jquery.elastislide
//= require gallery
//= require jquery_ujs
//= require jquery-ui
//= require plupload/plupload.full.min.js
//= require jquery.formstyler
//= require social-share-button
//= require social-share-button/wechat
//= require_tree .
//= require jquery.validationEngine
//= require noty/jquery.noty
//= require noty/layouts/top
//= require noty/layouts/topRight
//= require noty/themes/default
//= require noty/themes/relax
//= require jquery.waypoints.min
//= require jquery.counterup.min
//= require inputmask
//= require jquery.inputmask
//= require inputmask.numeric.extensions
//= require jquery.maskMoney
//= require js-routes
//= require jquery.raty
//= require ratyrate
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-IE
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es
//= require jquery.ui.touch-punch.min
//= require jquery.confirm.min

function deletePhoto(event, listingId, photoId){
    event.stopPropagation();
    event.preventDefault();
    var url = '/listings/' + listingId + '/listing_photos/' + photoId;
    $.ajax({
        url: url ,
        method: 'DELETE',
        dataType: 'script'
    });
}


function isBlank(string){
    if(string == "" || string == null || string == undefined) {
        return true;
    }else{
        return false;
    }
}

$.noty.defaults = {
    layout: 'topRight',
    theme: 'relax', // or relax
    type: 'alert', // success, error, warning, information, notification
    text: '', // can be HTML or STRING

    dismissQueue: true, // If you want to use queue feature set this true
    force: false, // adds notification to the beginning of queue when set to true
    maxVisible: 5, // you can set max visible notification count for dismissQueue true option,

    template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>',

    timeout: 10000, // delay for closing event in milliseconds. Set false for sticky notifications
    animation: {
        open: {height: 'toggle'}, // or Animate.css class names like: 'animated bounceInLeft'
        close: {height: 'toggle'}, // or Animate.css class names like: 'animated bounceOutLeft'
        easing: 'swing',
        speed: 500 // opening & closing animation speed
    },
    closeWith: ['click', 'button'], // ['click', 'button', 'hover', 'backdrop'] // backdrop click will close all notifications

    modal: false, // if true adds an overlay
    killer: false, // if true closes all notifications and shows itself

    callback: {
        onShow: function() {},
        afterShow: function() {},
        onClose: function() {},
        afterClose: function() {},
        onCloseClick: function() {},
    },

    buttons: false, // an array of buttons, for creating confirmation dialogs.layout: 'top',
};

//From: http://thelazylog.com/custom-dialog-for-data-confirm-in-rails/
//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}
//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  $.confirm({
    title: '<img class="img-responsive" src="/assets/watermark.png" width="250px"/>',
    content: message,
    buttons: {
        confirm: {
            text: I18n.t('listings.show.confirm'),
            btnClass: 'btn btn-success',
            action: function () {
                $.rails.confirmed(link);
            }
        },        
        no: {
            text: I18n.t('listings.show.cancel'),
            btnClass: 'btn btn-default btn-sm',
        },     
    }
});
}


//todo: figure out why tooltips looks like crap

$(function () {

    $("img.lazy").lazyload();

    $('[data-toggle="tooltip"]').tooltip();
    $("#btnRegister").on('click', function() {
        $('#registration').modal('show');
        $('#join').tab('show');
    });
    $('#user_avatar').on('change', function() {
        var f = $('#user_avatar')[0].files[0];
        var reader = new FileReader();
        reader.onload = (function(theFile) {
            return function(e) {
                $('.img-avatar').attr('src',e.target.result);
            };
        })(f);
        reader.readAsDataURL(f);
        $('#user_avatar_submit').show();
    });
    $('.user-avatar').on('change', function() {
        var target = $(this).data('preview');
        var f = $(this)[0].files[0];
        var reader = new FileReader();
        reader.onload = (function(theFile) {
            return function(e) {
                $(target).attr('src',e.target.result);
            };
        })(f);
        reader.readAsDataURL(f);
    });

});

/*
 development only: function to print properties for a given new listing
 */
function printAllInputs(){
    $('select[name="listing[type]"] option').each(function(){
        console.log($(this).val());
        getInputs($(this).val().toLowerCase());
    });
}
function getInputs(type){
    var a = [], b = [], c = [];
    $('#new_'+type+' input[name*="listing[properties]"],#new_'+type+' select[name*="listing[properties]"]').each(function() {
        a.push($(this).attr('name').replace('listing[properties][',"").replace("]",""));
    });
    $('#new_'+type+' input[name="listing[properties][amenities][]"]').each(function() {
        b.push($(this).val());
    });
    $('#new_'+type+' input[name="listing[properties][rooms][]"]').each(function() {
        c.push($(this).val());
    });
    console.log("Properties: "+a.join(","));
    console.log("Amenities: "+b.join(","));
    console.log("Rooms: " + c.join(","));
}

$(function(){

    $("input[name^='listing[list_price]']").keyup(function() {

        // skip for arrow keys
        if(event.which >= 37 && event.which <= 40) return;

        // this.value = $(this).val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
        console.log('*');
        // $(this).val(function(index, value) {
        //   value = value
        //   return value
        //   .replace(/\D/g, "")
        //   .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        //   ;
        // });
    });

    // FULLSCREEN MODAL
    $(".modal-fullscreen").on('show.bs.modal', function () {
        setTimeout( function() {
            $(".modal-backdrop").addClass("modal-backdrop-fullscreen");
        }, 0);
    });
    $(".modal-fullscreen").on('hidden.bs.modal', function () {
        $(".modal-backdrop").addClass("modal-backdrop-fullscreen");
    });

    //BACK BROWSER EVENT AND TABS
    // add a hash to the URL when the user clicks on a tab
    $('a[data-toggle="tab"]').on('click', function(e) {
        history.pushState(null, null, $(this).attr('href'));
    });
    // navigate to a tab when the history changes
    window.addEventListener("popstate", function(e) {
        var activeTab = $('[href="' + location.hash.toString() + '"]');
        if (activeTab.length) {
            activeTab.tab('show');
        } else {
            $('.nav-tabs a:first').tab('show');
        }
    });

    var url = document.location.toString();
    if (url.match('#')) {
        var tab = url.split('#')[1];
        var firstTab = $('a[href="#' + tab + '"]');
        firstTab.tab('show');
        // check if it is into another tab
        var secondTabContainer = firstTab.closest('.tab-pane');
        if(secondTabContainer.length){
            var secondTab = $('a[href="#' + secondTabContainer.attr('id') + '"]');
            secondTab.tab('show');
        }
    }


    $("form.validate").validationEngine();


});

var showMessages = function(messages){
    for(var i = 0; i < messages.length; i++) {
        noty({type: messages[i][0], text: messages[i][1]});
    }
};

var initDatepicker = function(){
    $('input.datepicker').datepicker({language: I18n.locale});
}

var maskMoney = function(){
    var currentLocale = I18n.currentLocale();
    $("input.money").maskMoney({allowEmpty: true, thousands: I18n.t('number.currency.format.delimiter'), precision:  I18n.t('number.currency.format.precision'), decimal: I18n.t('number.currency.format.separator')});
};

// From: http://www.falconmasters.com/web-design/boton-ir-arriba-javascript/
var goToTop = function(){
    $('.go-to-top').click(function(){
        $('body, html').animate({
            scrollTop: '0px'
        }, 300);
    });
 
    $(window).scroll(function(){
        if( $(this).scrollTop() > 0 ){
            $('.go-to-top').slideDown(300);
        } else {
            $('.go-to-top').slideUp(300);
        }
    });
};

$(function(){
    $(document).on('submit', 'form', function(){
        $('input.money').each(function(i, elem){
            var thiz = $(elem);
            var unmaskedValue = thiz.maskMoney('unmasked')[0];
            if(unmaskedValue != 0){
                thiz.val(unmaskedValue);
            }
        });
    });
});
