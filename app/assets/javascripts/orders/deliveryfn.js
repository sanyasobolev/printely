(function () {
    // Initialize namespace (or use existing one if present)
    window.deliveryfn = window.deliveryfn || {};

    // Add function  to the namespace
    
    deliveryfn.clear_select = function(){
	    $("select#order_delivery_town_id").change(function(event){
	    	$('[value=""]',event.target).remove();
	    });
     };
     
    
	 deliveryfn.update_order = function(order){
     	$("select#order_delivery_town_id").change(function(event){
	            var selected_delivery = 'Курьер',
	            	selected_town = $(this).val();
	            uploadfn.show_loader_for_div("order_delivery_price_value");	
	            $.post( order.url_for_update_delivery_price, 
	            		{
	            			id: order.order_id, 
	            		 	delivery_type: selected_delivery,
	            		 	delivery_town: selected_town
	            		 } 
	            	   );
	        });  

	        $("table td.delivery_date_edit input#datepicker").change(function(event){
	            var selected_delivery_date = $(this).val(),
	                selected_delivery = 'Курьер';
	            uploadfn.show_loader_for_div("order_delivery_price_value");	
	            $.post( order.url_for_update_delivery_price, 
	            	{
	            		id: order.order_id, 
	            		delivery_type: selected_delivery,
	            		delivery_date: selected_delivery_date 
	            	} );
	        });  	
	};

   

})();