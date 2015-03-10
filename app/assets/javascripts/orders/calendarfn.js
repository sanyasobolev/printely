(function () {
    // Initialize namespace (or use existing one if present)
    window.calendarfn = window.calendarfn || {};

    // Add function  to the namespace
	
	//время
     calendarfn.set_timepicker = function(selector, minTime, maxTime){
        $(selector).timepicker(
        	{ 
        		'timeFormat': 'H:i', 
        		'scrollDefaultNow': true, 
        		'minTime': minTime, 
        		'maxTime': maxTime
        		}
        );
     };	
	
	   //календарь
	   calendarfn.set_datepicker = function(selector, minDate, changeMonth){
	        $(selector).datepicker({
				minDate: minDate, //первая дата, которую можно выбрать, minDate: new Date(2014, 7 - 1, 15),
				firstDay: 1, //Set the first day of the week: Sunday is 0, Monday is 1, etc.
				beforeShowDay: calendarfn.highlightDays, //A function that takes a date
				}
			);
	   };

		
		//подсветка дат при выборе доставки
	    calendarfn.highlightDays = function(date) {
	    	if (gon.delivery_dates != null ){
	    		var dates = [];	
	    		for (var k = 0; k < gon.delivery_dates.length; k++) {
	    			dates[k] = calendarfn.format_date(gon.delivery_dates[k]);
	    			dates[k] = new Date(dates[k]);
	              	if (dates[k].getTime() == date.getTime()) {
	                             		return [true, 'highlight_delivery_date'];
	                     				}
	    		}
	    		return [true, ''];
	    	}      
	    };

		calendarfn.format_date = function(input) {
			  var datePart = String(input).match(/\d+/g),
			  year = datePart[0], 
			  month = datePart[1], 
			  day = datePart[2];
			
			  return year+','+month+','+day;
		};

	    calendarfn.set_datepicker_interval = function(){
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
	    };



		
})();
	  
