(function () {
    // Initialize namespace (or use existing one if present)
    window.deliveryfn = window.deliveryfn || {};

    // Add function  to the namespace
    
    deliveryfn.clear_select = function(){
	    $("select#order_delivery_town_id").change(function(event){
	    	$('[value=""]',event.target).remove();
	    });
     };
     
     deliveryfn.delivery_timepicker = function(){
        $('#timepicker_start').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:00', 'maxTime': '23:30' });
        $('#timepicker_end').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:30', 'maxTime': '00:00' });
     };
   

})();