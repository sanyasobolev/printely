jQuery.fn.exists = function() {
    return $(this).length;
}


$(document).ready(function(){
	   //календарь
        $("#datepicker, #datepicker_2, #datepicker_3, #datepicker_4").datepicker({
			minDate: 0,
			firstDay: 1,
			}
		);
   
	    $( ".date_from" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_to" ).datepicker( "option", "minDate", selectedDate );
	      }
	    });
	    
	    $( ".date_to" ).datepicker({
	      defaultDate: "+1w",
	      changeMonth: true,
	      numberOfMonths: 3,
	      onClose: function( selectedDate ) {
	        $( "#date_from" ).datepicker( "option", "maxDate", selectedDate );
	      }
	    });
	  });
	  
