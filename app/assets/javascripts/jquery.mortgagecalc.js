/**
 * A Simple jQuery based mortgage calculator.
 *
*/


var MortgageCalc = {
	_create: function() {
    var self = this;
    $(self.element).find('button').click($.proxy(self._event_calculate,self))
	},
  _get_monthly_payment: function() {
    var PR = this._get_val('price') - this._get_val('down_payment');
    var IN = (this._get_val('interest_rate') * 0.01) / 12;
    var PE = this._get_val('loan_term');
    var payment = (PR * IN) / (1 - Math.pow(1 + IN, -PE))
    payment = this._round_number(payment,2);
    return payment;
  },
  _get_val: function(val) {

    var thiz = $(this.element).find('input[name=' + val + ']');
    var unmaskedValue = thiz.maskMoney('unmasked')[0];
    var _v = parseFloat(unmaskedValue);
    if(!isNaN(_v)) {
      return _v;
    }
    if(!isNaN(parseFloat(this.options[val]))) {
      return parseFloat(this.options[val]);
    }
    return 0;
  },
  _get_down_payment_rate: function() {
    var price = this._get_val('price');
    var dpmt = this._get_val('down_payment');
    return this._round_number((dpmt/price) * 100,2);
  },
  _round_number: function(value,decimal_len) {
    return Math.round(value * Math.pow(10,decimal_len))/Math.pow(10,decimal_len);
  },
  _event_calculate: function() {
    $('.money').inputmask('unmaskedvalue');
    $(this.element).find('#down_payment_rate').html(this._get_down_payment_rate());
    $(this.element).find('#monthly_payment').html(I18n.toNumber(this._get_monthly_payment().toString(), {precision: I18n.t('number.currency.format.precision'), separator: I18n.t('number.currency.format.separator')}));
      //$(this.element).find('#monthly-payment-container').effect('highlight', {color: 'yellow'}, 1000);
    $(this.element).find('#monthly-payment-container span').counterUp();
  },
 	options: {
    price: 0,
    down_payment: 0,
    loan_term: 360,
    interest_rate: 4.25,
    add_css: true
	}
};
$.widget ('ui.mortgagecalc', MortgageCalc);