$(document).ready(function(){
	
	   //календарь
        $("#datepicker, #datepicker_2, #datepicker_3, #datepicker_4").datepicker({
			minDate: 0,
			//minDate: new Date(2014, 7 - 1, 15),
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

		
});
	  
