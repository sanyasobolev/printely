jQuery.fn.exists = function() {
    return $(this).length;
};

$(document).ready(function(){
	   //календарь
        $("#datepicker, #datepicker_2, #datepicker_3, #datepicker_4").datepicker({
			minDate: 0,
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
	if($("table.order_delivery input").exists()) {
        var url_for_update_order = "/order/ajaxupdate",
            order_id = $("form").attr("id");
            
        $("table.order_delivery select#order_delivery_street").change(function(event){
            var selected_delivery = 'Курьер';
            $.post( url_for_update_order, {id: order_id, delivery_type: selected_delivery} );
        });  
        
        $("table.order_delivery input#order_delivery_address").change(function(event){
            var selected_delivery = 'Курьер';
            $.post( url_for_update_order, {id: order_id, delivery_type: selected_delivery} );
        }); 

        $("table.order_delivery input#datepicker").change(function(event){
            var selected_delivery = 'Курьер',
                selected_deleivery_date = $(this).val();
            $.post( url_for_update_order, {id: order_id, delivery_type: selected_delivery, delivery_date: selected_deleivery_date } );
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
	  
