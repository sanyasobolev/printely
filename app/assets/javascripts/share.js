$(document).ready(function(){
	
	$("div#call").click(function() {
		$("div.phone_popup").css("display", "block");
	});
	
	$("div.phone_popup .exit").click(function() {
		$("div.phone_popup").css("display", "none");
	});

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
	  
