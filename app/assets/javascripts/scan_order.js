$(document).ready(function(){
    if(($(".edit_scan_order").exists()) || ($(".admin_scan_order").exists())) {
       
		var url_for_update_order = "/order/ajaxupdate",
        url_for_update_scan = "/scan/ajaxupdate",
        url_for_create_scan = "/scan/create",
        
        selected_scan_documents_quantity = $("input#order_scan_scan_documents_quantity"),
        selected_base_correction_documents_quantity = $("input#order_scan_base_correction_documents_quantity"),
        selected_coloring_documents_quantity = $("input#order_scan_coloring_documents_quantity"),
        selected_restoration_documents_quantity = $("input#order_scan_restoration_documents_quantity");

		if ($(".edit_scan_order").exists()) {
			//set out control
	        $(".edit_scan_order").FormNavigate({
    	      message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
        	  aOutConfirm: "a.button_style"
    	    });

			//client validator
	        $("form.edit_scan_order").validate({
	    		rules: {
	    			'order[delivery_address]': "required",
	    			'order[delivery_street]':"required",
	    			'order[delivery_date]':"required"
	    		},
	    		messages: {
	    			'order[delivery_address]': "?",
	    			'order[delivery_street]':"?",
	    			'order[delivery_date]':"?"
	    		}
	    		}
	        );

			//set default
			var order_id = $("form.edit_scan_order").attr("id"),
				button_improve_documents = $("button#improve_documents_toggle"),
				button_base_correction = $("button#scan_base_correction"),
		        button_coloring = $("button#scan_coloring"),
		        button_restoration = $("button#scan_restoration"),
		        
		        button_base_correction_example = $("button#base_correction_example"),
		        button_coloring_example = $("button#coloring_example"),
		        button_restoration_example = $("button#restoration_example"),
		        
		        button_why_pre_cost = $("button#why_pre_cost_link"),
		        
		        selected_scan_documents_quantity = $("input#order_scan_scan_documents_quantity"),
		        selected_base_correction_documents_quantity = $("input#order_scan_base_correction_documents_quantity"),
		        selected_coloring_documents_quantity = $("input#order_scan_coloring_documents_quantity"),
		        selected_restoration_documents_quantity = $("input#order_scan_restoration_documents_quantity");
		
					
			selected_scan_documents_quantity.val(1);
			$.post( url_for_create_scan, {order_id: order_id, scan_documents_quantity: selected_scan_documents_quantity.val()},
			    	function() {
	                	$.post( url_for_update_order, {id: order_id} );
	  				}
			 );

			//события кнопки Улучшить документы
			button_improve_documents.click(function () {
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#improve_document_parameters").slideToggle("fast");
				} else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#improve_document_parameters").slideToggle("fast");
				}
	    	});
	        
	        //события по клику на параметре улучшения
			button_base_correction.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#base_correction_documents_quantity").slideDown("fast");
					selected_base_correction_documents_quantity.val(1);
					if (selected_scan_documents_quantity.val()== 1 ){
						inactivate_button(button_coloring);
						inactivate_button(button_restoration);
					}
			          $.post( url_for_update_scan, 
			          	{order_id: order_id, selected_base_correction_documents_quantity: selected_base_correction_documents_quantity.val()},
			          	function() {
			               $.post( url_for_update_order, {id: order_id} );
			  				}
			          	 );
				}
				else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#base_correction_documents_quantity").slideUp("fast", function(){
						selected_base_correction_documents_quantity.val(0);
				        $.post( url_for_update_scan, 
				        	{order_id: order_id, selected_base_correction_documents_quantity: selected_base_correction_documents_quantity.val()},
				        	function() {
				             $.post( url_for_update_order, {id: order_id} );
							}
			          	 );
					});
					activate_button(button_coloring);
					activate_button(button_restoration);
				}
			});
	
			button_base_correction_example.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#base_correction_example_area").slideDown("fast");
				} else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#base_correction_example_area").slideUp("fast");
				}
			});
			
			button_coloring_example.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#coloring_example_area").slideDown("fast");
				} else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#coloring_example_area").slideUp("fast");
				}
			});
			
			button_restoration_example.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#restoration_example_area").slideDown("fast");
				} else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#restoration_example_area").slideUp("fast");
				}
			});
	
			button_coloring.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#coloring_documents_quantity").slideDown("fast");
					selected_coloring_documents_quantity.val(1);
					if (selected_scan_documents_quantity.val()== 1 ){
						inactivate_button(button_base_correction);
					}
				        $.post( url_for_update_scan, 
				        	{order_id: order_id, selected_coloring_documents_quantity: selected_coloring_documents_quantity.val()},
				        	function() {
				             $.post( url_for_update_order, {id: order_id} );
							}
			          	 );
				}
				else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#coloring_documents_quantity").slideUp("fast", function(){
						selected_coloring_documents_quantity.val(0);
				        $.post( url_for_update_scan, 
				        	{order_id: order_id, selected_coloring_documents_quantity: selected_coloring_documents_quantity.val()},
				        	function() {
				             $.post( url_for_update_order, {id: order_id} );
							}
			          	 );
					});
					if (button_restoration.hasClass("button_style_long_orange")){
						activate_button(button_base_correction);
					} else if (button_restoration.hasClass("button_style_long_orange_pressed") & selected_restoration_documents_quantity.val() < selected_scan_documents_quantity.val()) {
						activate_button(button_base_correction);
					}
				}
			});
			
			button_restoration.bind('click', function(event){
				if ($(this).hasClass("button_style_long_orange")){
					$(this).removeClass("button_style_long_orange");
					$(this).addClass("button_style_long_orange_pressed");
					$("#restoration_documents_quantity").slideDown("fast");
					selected_restoration_documents_quantity.val(1);
					if (selected_scan_documents_quantity.val()== 1 ){
						inactivate_button(button_base_correction);
					}
				        $.post( url_for_update_scan, 
				        	{order_id: order_id, selected_restoration_documents_quantity: selected_restoration_documents_quantity.val()},
				        	function() {
				             $.post( url_for_update_order, {id: order_id} );
							}
			          	 );
				}
				else if ($(this).hasClass("button_style_long_orange_pressed")){
					$(this).removeClass("button_style_long_orange_pressed");
					$(this).addClass("button_style_long_orange");
					$("#restoration_documents_quantity").slideUp("fast", function(){
						selected_restoration_documents_quantity.val(0);
				        $.post( url_for_update_scan, 
				        	{order_id: order_id, selected_restoration_documents_quantity: selected_restoration_documents_quantity.val()},
				        	function() {
				             $.post( url_for_update_order, {id: order_id} );
							}
			          	 );
					});
					if (button_coloring.hasClass("button_style_long_orange")){
						activate_button(button_base_correction);
					} else if (button_coloring.hasClass("button_style_long_orange_pressed") & selected_coloring_documents_quantity.val() < selected_scan_documents_quantity.val()) {
						activate_button(button_base_correction);
					}
				}
			});
	        
	        //функции активации/дезактивации кнопок
	        function inactivate_button(button){
					if (button.hasClass("button_style_long_orange")){
						button.removeClass("button_style_long_orange");
						button.addClass("button_style_long_orange_inactive");
					}
	        };
	        
	        function activate_button(button){
		        	if (button.hasClass("button_style_long_orange_inactive")){
						button.removeClass("button_style_long_orange_inactive");
						button.addClass("button_style_long_orange");
					}
	        };
	
	        //работа переключателя количества документов для базовой коррекции
	        $("button.increase_quantity#base_correction").bind('click', function(event){
	           selected_base_correction_documents_quantity = $(this).siblings("input[id*='quantity']");
	          if (button_coloring.hasClass("button_style_long_orange_pressed") & button_restoration.hasClass("button_style_long_orange_pressed")){
	          	if (selected_coloring_documents_quantity.val() > selected_restoration_documents_quantity.val()){
	          		limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_coloring_documents_quantity.val());
	          	}
	          	else if (selected_coloring_documents_quantity.val() <= selected_restoration_documents_quantity.val()){
	          		limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_restoration_documents_quantity.val());
	
	          	}
		      }
	     
		      if (button_coloring.hasClass("button_style_long_orange_pressed") & button_restoration.hasClass("button_style_long_orange")){
	          	limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_coloring_documents_quantity.val());
		      }
	
		      if (button_restoration.hasClass("button_style_long_orange_pressed") & button_coloring.hasClass("button_style_long_orange")){
	          	limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_restoration_documents_quantity.val());
		      }
	
	          if ((button_coloring.hasClass("button_style_long_orange") & button_restoration.hasClass("button_style_long_orange")) | (button_coloring.hasClass("button_style_long_orange_inactive") & button_restoration.hasClass("button_style_long_orange_inactive"))){
				limit = selected_scan_documents_quantity.val();
				}
	
	          increase_quantity(selected_base_correction_documents_quantity, limit);
			  if (selected_base_correction_documents_quantity.val() == selected_scan_documents_quantity.val()){
			  		inactivate_button(button_coloring);
					inactivate_button(button_restoration);
			  }
			  
	        });
	        
	        $("button.decrease_quantity#base_correction").bind('click', function(event){
	          selected_base_correction_documents_quantity = $(this).siblings("input[id*='quantity']");
	          decrease_quantity(selected_base_correction_documents_quantity, selected_scan_documents_quantity.val());
	          if (selected_base_correction_documents_quantity.val() != selected_scan_documents_quantity.val()){
			  		activate_button(button_coloring);
					activate_button(button_restoration);
			  }
			  
	        });
	
	        //работа переключателя количества документов для раскраски
	        $("button.increase_quantity#coloring").bind('click', function(event){
	          selected_coloring_documents_quantity = $(this).siblings("input[id*='quantity']");
	          
		      if (button_base_correction.hasClass("button_style_long_orange_pressed")){
	          	limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_base_correction_documents_quantity.val());
		      } else {
		      	limit = selected_scan_documents_quantity.val();
		      }
	          
	          increase_quantity(selected_coloring_documents_quantity, limit);
	       	  if (selected_coloring_documents_quantity.val() == limit){
			  		inactivate_button(button_base_correction);
			  }
			  
	        });
	        $("button.decrease_quantity#coloring").bind('click', function(event){
	          selected_coloring_documents_quantity = $(this).siblings("input[id*='quantity']");
	          decrease_quantity(selected_coloring_documents_quantity, selected_scan_documents_quantity.val());
	       	  if (selected_coloring_documents_quantity.val() != selected_scan_documents_quantity.val() & selected_restoration_documents_quantity.val() != selected_scan_documents_quantity.val()){
			  		activate_button(button_base_correction);
			  }
	        });
	
	        //работа переключателя количества документов для реставрации
	        $("button.increase_quantity#restoration").bind('click', function(event){
	          selected_restoration_documents_quantity = $(this).siblings("input[id*='quantity']");
	          
		      if (button_base_correction.hasClass("button_style_long_orange_pressed")){
	          	limit = parseInt(selected_scan_documents_quantity.val()) - parseInt(selected_base_correction_documents_quantity.val());
		      } else {
		      	limit = selected_scan_documents_quantity.val();
		      }
	          
	          increase_quantity(selected_restoration_documents_quantity, limit);
	       	  if (selected_restoration_documents_quantity.val() == limit){
			  		inactivate_button(button_base_correction);
			  }
			  
	        });
	        $("button.decrease_quantity#restoration").bind('click', function(event){
	          selected_restoration_documents_quantity = $(this).siblings("input[id*='quantity']");
	          decrease_quantity(selected_restoration_documents_quantity, selected_scan_documents_quantity.val());
	       	  if (selected_restoration_documents_quantity.val() != selected_scan_documents_quantity.val() & selected_coloring_documents_quantity.val() != selected_scan_documents_quantity.val()){
			  		activate_button(button_base_correction);
			  }
	        });

		//increase/decrease input quantity
		function increase_quantity(selected_input_quantity, limit){
		  new_value = parseInt(selected_input_quantity.val()) + 1 ;
          new_value = validate(new_value, limit);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
		};
		
		function decrease_quantity(selected_input_quantity, limit){
		  new_value = parseInt(selected_input_quantity.val()) - 1 ;
          new_value = validate(new_value, limit);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
		};
		
		button_why_pre_cost.bind('click', function(event){
			$("div#why_pre_cost_text").slideToggle("fast");
		});
        
		}; //конец функции для edit_scan_order
				
		if ($(".admin_scan_order").exists()){
			
			//set out control
	        $(".admin_scan_order").FormNavigate({
    	      message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
        	  aOutConfirm: "a.button_style"
    	    });
			
			//client validator
	        $("form.admin_scan_order").validate({
	    		rules: {
	    			'order[delivery_address]': "required",
	    			'order[delivery_street]':"required",
	    			'order[delivery_date]':"required"
	    		},
	    		messages: {
	    			'order[delivery_address]': "?",
	    			'order[delivery_street]':"?",
	    			'order[delivery_date]':"?"
	    		}
	    		}
	        );
			
			var order_id = $("form.admin_scan_order").attr("id"),
		        selected_scan_documents_quantity = $("input#order_scan_attributes_scan_documents_quantity"),
		        selected_base_correction_documents_quantity = $("input#order_scan_attributes_base_correction_documents_quantity"),
		        selected_coloring_documents_quantity = $("input#order_scan_attributes_coloring_documents_quantity"),
		        selected_restoration_documents_quantity = $("input#order_scan_attributes_restoration_documents_quantity");
				
			$.post( url_for_update_scan, {order_id: order_id, scan_documents_quantity: selected_scan_documents_quantity.val()},
			    	function() {
	                	$.post( url_for_update_order, {id: order_id} );
	  				}
			 );
			
			
	        //события переключателя количества документов для базовой коррекции
	        $("button.increase_quantity#base_correction").bind('click', function(event){
	          new_value = parseInt(selected_base_correction_documents_quantity.val()) + 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_base_correction_documents_quantity.val(new_value);
	          selected_base_correction_documents_quantity.change();
	        });
	        $("button.decrease_quantity#base_correction").bind('click', function(event){
	          new_value = parseInt(selected_base_correction_documents_quantity.val()) - 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_base_correction_documents_quantity.val(new_value);
	          selected_base_correction_documents_quantity.change();
	        });
	        
	        //события переключателя количества документов для раскраски
	        $("button.increase_quantity#coloring").bind('click', function(event){
	          new_value = parseInt(selected_coloring_documents_quantity.val()) + 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_coloring_documents_quantity.val(new_value);
	          selected_coloring_documents_quantity.change();
	        });
	        $("button.decrease_quantity#coloring").bind('click', function(event){
	          new_value = parseInt(selected_coloring_documents_quantity.val()) - 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_coloring_documents_quantity.val(new_value);
	          selected_coloring_documents_quantity.change();
	        });
	        
	        //события переключателя количества документов для реставрации
	        $("button.increase_quantity#restoration").bind('click', function(event){
	          new_value = parseInt(selected_restoration_documents_quantity.val()) + 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_restoration_documents_quantity.val(new_value);
	          selected_restoration_documents_quantity.change();
	        });
	        $("button.decrease_quantity#restoration").bind('click', function(event){
	          new_value = parseInt(selected_restoration_documents_quantity.val()) - 1 ;
	          new_value = validate(new_value, 100, 0);
	          selected_restoration_documents_quantity.val(new_value);
	          selected_restoration_documents_quantity.change();
	        });
        
		};
	
        //события переключателя количества сканированных документов
        $("button.increase_large").bind('click', function(event){
          new_value = parseInt(selected_scan_documents_quantity.val()) + 1 ;
          new_value = validate(new_value);
          selected_scan_documents_quantity.val(new_value);
          selected_scan_documents_quantity.change();
        });
        $("button.decrease_large").bind('click', function(event){
          new_value = parseInt(selected_scan_documents_quantity.val()) - 1 ;
          new_value = validate(new_value);
          selected_scan_documents_quantity.val(new_value);
          selected_scan_documents_quantity.change();
        });

        selected_scan_documents_quantity.bind('change', function(event){
          $.post( url_for_update_scan, 
          	{order_id: order_id, selected_scan_documents_quantity: $(this).val()},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 );
        });
        
        
        selected_base_correction_documents_quantity.bind('change', function(event){
          $.post( url_for_update_scan, 
          	{order_id: order_id, selected_base_correction_documents_quantity: $(this).val()},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 );
        });


        selected_coloring_documents_quantity.bind('change', function(event){
          $.post( url_for_update_scan, 
          	{order_id: order_id, selected_coloring_documents_quantity: $(this).val()},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 );
        });


        selected_restoration_documents_quantity.bind('change', function(event){
          $.post( url_for_update_scan, 
          	{order_id: order_id, selected_restoration_documents_quantity: $(this).val()},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 );
        });	

        //проверка значения количества
        function validate(value, up_limit, down_limit){
          if (isNaN(up_limit) == true) {
          	up_limit = 100; 
          	};
          
          if (isNaN(down_limit) == true) {
          	down_limit = 1; 
          	}; 	
          	
          if (value < down_limit || isNaN(value) == true) {
            value = down_limit;
          } else if (value > up_limit) {
            value = up_limit;
          }
          return value;
        };
		
        //clear value 'выберите' in select
        $("select#order_delivery_street").change(function(event){
            $('[value=""]',event.target).remove();
        });
		
		//time
        $('#timepicker_start').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:00', 'maxTime': '23:30' });
        $('#timepicker_end').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:30', 'maxTime': '00:00' });
    }
  });

