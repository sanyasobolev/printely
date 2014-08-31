$(document).ready(function(){
	
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
		
		//custom search
	    $('form').on('click', '.remove_fields', function(event) {
	      $(this).closest('.field').remove();
	      return event.preventDefault();
	    });
	    return $('form').on('click', '.add_fields', function(event) {
	      var regexp, time;
	      time = new Date().getTime();
	      regexp = new RegExp($(this).data('id'), 'g');
	      $(this).before($(this).data('fields').replace(regexp, time));
	      return event.preventDefault();
	    });
		
});
	  
