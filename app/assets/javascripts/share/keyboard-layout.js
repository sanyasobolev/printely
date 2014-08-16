(function() {

  jQuery.keyboardLayout = {};
  jQuery.keyboardLayout.indicator = $('<span class="keyboardLayout" />');
  jQuery.keyboardLayout.target;
  jQuery.keyboardLayout.layout;
  jQuery.keyboardLayout.show = function(layout){
    this.layout = layout;
    this.indicator.text(layout);
    this.target.after(this.indicator);
  };

  jQuery.keyboardLayout.hide = function(){
    this.target = null;
    this.layout = null;
    this.indicator.remove();
  };

  jQuery.fn.keyboardLayout = function()
  {
    this.each(function(){

      $(this).focus(function(){
        jQuery.keyboardLayout.target = $(this);
      });

      $(this).blur(function(){
        jQuery.keyboardLayout.hide();
      });

      $(this).keypress(function(e){
        var c = (e.charCode == undefined ? e.keyCode : e.charCode);
        var layout = jQuery.keyboardLayout.layout;
		 if (c >= 65/*A*/ && c <= 90/*Z*/  && !e.shiftKey ||
             c >= 97/*a*/ && c <= 122/*z*/ &&  e.shiftKey) {

          layout = 'Caps Lock включен';

        } else if (c >= 1072/*а*/ && c <= 1103/*я*/ ||
                   c >= 1040/*А*/ && c <= 1071/*Я*/ ||
                    c == 1105/*ё*/ ||
                    c == 1025/*Ё*/ ||
                    c == 34/*"*/   &&  e.shiftKey ||
                    c == 8470/*№*/ &&  e.shiftKey ||
                    c == 59/*;*/   &&  e.shiftKey ||
                    c == 58/*:*/   &&  e.shiftKey ||
                    c == 63/*?*/   &&  e.shiftKey ||
                    c == 47/*/*/   &&  e.shiftKey ||
                    c == 46/*.*/   &&  e.shiftKey ||
                    c == 44/*,*/   &&  e.shiftKey) {

          layout = 'Смените язык';

        } else {
        	layout = ' ';
        }
        if (layout) {
            jQuery.keyboardLayout.show(layout);
        }
      });
    });
  };

})();