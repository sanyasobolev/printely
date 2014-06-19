jQuery.fn.exists = function() {
    return $(this).length;
};


jQuery.fn.extend({
  FormNavigate: function(o){
    var formdata_original = false;
    jQuery(window).bind('beforeunload', function (){
      if (!formdata_original) return settings.message;
    });

    var def = {
      message: '',
      aOutConfirm: 'a:not([target!=_blank])'
    };
    var settings = jQuery.extend(false, def, o);

//    jQuery(this).find("input[type=text], textarea, select, input[type='password'], input[type='radio'], input[type='checkbox'], input[type='file']").live('change keypress', function(event){
//      formdata_original = false;
//    });


  //фильтрация ссылок на странице по входному параметру--------------------------------------
    if (o.aOutConfirm && o.aOutConfirm != def.aOutConfirm){
      jQuery('a').addClass('aOutConfirmPlugin');
      jQuery(settings.aOutConfirm).removeClass("aOutConfirmPlugin");
      jQuery(settings.aOutConfirm).click(function(){
        formdata_original = true;
        return true;
      });
    }

    jQuery("a.aOutConfirmPlugin").click(function(){
      if (formdata_original == false)
        if(confirm(settings.message)) //если нажали ок в окне, то
          formdata_original = true;
      return formdata_original;
    });

    jQuery(this).find(":submit, input[type='submit']").click(function(){
      formdata_original = true;
    });
    
  }
});

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

$(document).ready(function(){

	if($("#slide_orders").exists()){
			$('#slide_orders').carouFredSel({
					       prev : "left",
					       next : "right",
					       height: "variable",
					       auto : false,
					       swipe: {
					              onTouch	: true,
					              onMouse	: true
					             },
					       circular: false,
					       items: 1,
					       align: "center",
					       cookie: true,
					       pagination: {
					                 container: '#slide_img_pag',
					                 anchorBuilder: function(nr) { 
					                 	if (nr == '1'){
					                 		return '<a href="#"><span>На печать фото</span></a>';
					                 	} else if (nr == '2'){
					                 		return '<a href="#"><span>На печать документов</span></a>';	
					                 	} else if (nr == '3'){
					                 		return '<a href="#"><span>На сканирование</span></a>';
					                 	}					                 	
					                 	}
					               }
					     });
			};

	if($("#slide_image").exists()){
	 	$(window).bind('resize.x', function() {
	                    $('#slide_image').carouFredSel({
	                            prev : "left",
	                            next : "right",
	                            swipe: {
	                                onTouch	: true,
	                                onMouse	: true
	                            },
	                            circular: true,
	                            items: 1,
	                            width: $(window).width(),
	                            cookie: true,
	                            auto : {
	                                pauseDuration: 7000
	                            },
	                            pagination: {
	                                    container: '#slide_img_pag'
	                            }
	                    });
	                    
	              }).trigger('resize.x');
      };
	
	//проверка раскладки
	$(function(){
		$(':password').keyboardLayout();
	});
	
	   //календарь
        $("#datepicker, #datepicker_2, #datepicker_3, #datepicker_4").datepicker({
			minDate: 0,
			//minDate: new Date(2014, 5 - 1, 12),
			firstDay: 1,
			beforeShowDay: highlightDays
			}
		);
		
		//подсветка дат при выборе доставки
	    function highlightDays(date) {
	    	if (gon.delivery_dates != null ){
	    		var dates = [];	
	    		for (var k = 0; k < gon.delivery_dates.length; k++) {
	    			dates[k] = format_date(gon.delivery_dates[k]);
	    			dates[k] = new Date(dates[k]);
	              	if (dates[k].getTime() == date.getTime()) {
	                             		return [true, 'highlight_delivery_date'];
	                     				}
	    		}
	    		return [true, ''];
	    	}      
	    };

		function format_date(input) {
			  var datePart = String(input).match(/\d+/g),
			  year = datePart[0], 
			  month = datePart[1], 
			  day = datePart[2];
			
			  return year+','+month+','+day;
		};

	    $( "#date_from" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_to" ).datepicker( "option", "minDate", selectedDate );
	      }
	    });
	    
	    $( "#date_to" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_from" ).datepicker( "option", "maxDate", selectedDate );
	      }
	    });

	    $( "#date_from_2" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_to_2" ).datepicker( "option", "minDate", selectedDate );
	      }
	    });
	    
	    $( "#date_to_2" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_from_2" ).datepicker( "option", "maxDate", selectedDate );
	      }
	    });

        //при любом изменении в таблице, устанавливаем тип доставки "курьер"
		if($("table td.delivery_location_edit input").exists()) {
	        var url_for_update_order = "/order/ajaxupdate",
	            order_id = $("form").attr("id");
	            
	        $("table td.delivery_location_edit select#order_delivery_town_id").change(function(event){
	            var selected_delivery = 'Курьер',
	            	selected_town = $(this).val();
	            	
	            $.post( url_for_update_order, 
	            		{
	            			id: order_id, 
	            		 	delivery_type: selected_delivery,
	            		 	delivery_town: selected_town
	            		 } 
	            	   );
	        });  

	        $("table td.delivery_date_edit input#datepicker").change(function(event){
	            var selected_delivery_date = $(this).val();
	            $.post( url_for_update_order, 
	            	{
	            		id: order_id, 
	            		delivery_date: selected_delivery_date 
	            	} );
	        }); 
          
	};
	
    	//float header for show order view
		if ($("div.container_for_label_cost_order").exists()) {
		$('table#fileList').floatThead({
			floatTableClass: 'floatTheadfileListOrder',
			debounceResizeMs: 100
			});
		}
		
});
	  
