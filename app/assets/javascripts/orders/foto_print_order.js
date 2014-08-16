$(document).ready(function(){
	if(($(".edit_foto_print_order").exists()) || ($(".admin_foto_print_order").exists())) {

        //clear value 'выберите' in select
        $("select#order_delivery_town_id").change(function(event){
            $('[value=""]',event.target).remove();
        });

        var url_for_update_order = "/order/ajaxupdate",
            url_for_update_document = "/document/price_update",
            url_for_load_paper_sizes = "/document/get_paper_sizes",
            url_for_load_paper_types = "/document/get_paper_types",
            url_for_load_print_margins = "/document/get_print_margins";
    
    if($(".edit_foto_print_order").exists()) {
    	
    	var order_id = $("form.edit_foto_print_order").attr("id");
    	
        //контроль ухода пользователя со страницы
        $(".edit_foto_print_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style, a.link_delete_docfile"
        });
        
        //client validator
        $("form.edit_foto_print_order").validate({
        	ignore: "",
    		rules: {
    			'order[delivery_address]': "required",
    			'order[delivery_town_id]':"required",
    			'order[delivery_date]':"required",
    			'quantity_documents_for_validate':"required"
    		},
    		messages: {
    			'order[delivery_address]': "?",
    			'order[delivery_town_id]':"?",
    			'order[delivery_date]':"?",
    			'quantity_documents_for_validate':"Загрузите файлы."
    		}
    		});
    }//end edit_foto_print_order
	
    if($(".admin_foto_print_order").exists()) {
    	
    	var order_id = $("form.admin_foto_print_order").attr("id");
    	
        //контроль ухода пользователя со страницы
        $(".admin_foto_print_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style, a.link_delete_docfile"
        });
        
        //client validator
        $("form.admin_foto_print_order").validate({
        	ignore: "",
			rules: {
    			'order[delivery_address]': "required",
    			'order[delivery_town_id]':"required",
    			'order[delivery_date]':"required",
    			'quantity_documents_for_validate':"required"
    		},
    		messages: {
    			'order[delivery_address]': "?",
    			'order[delivery_town_id]':"?",
    			'order[delivery_date]':"?",
    			'quantity_documents_for_validate':"Загрузите файлы."
    		}
    		});
        };//end admin_foto_print_order

                  
        //подключение хендлеров по управлению ценой (при уже загруженных документах - в случае рефреша страницы)

        //load paper_sizes------------------------------------------------------------------------------------
        $("select[name*='paper_size']").on("load_sizes", function(event) {
        	var document_id = this.parentNode.parentNode.parentNode.id;
        	$(this).load(
	     		url_for_load_paper_sizes, 
	        	{order_id: order_id, id: document_id, order_type: 'foto_print'},
	        	function(){
	        		$(this).change();
	        		});        	
        	});
		$("select[name*='paper_size']:not([class*='with_loaded_paper_sizes'])").addClass("with_loaded_paper_sizes").trigger("load_sizes");
 
		
        //change handler for load paper_types
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").change(function(event){
        	var selected_paper_size = $(this).val(),
        	document_id = this.parentNode.parentNode.parentNode.id;
        	show_loader_for_price(document_id);
        	$("select[name*='["+document_id+"][paper_type]']").load(
        		url_for_load_paper_types, 
        		{selected_paper_size: selected_paper_size, order_id: order_id, id: document_id, order_type: 'foto_print'},
        		function(){
        			$(this).attr("disabled",false);
        			$("select[name*='["+document_id+"][margins]']").attr("disabled",false);
        			$(this).change();
        		}
        		);
        	
        });


        //change handler for load print margins
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
        	var document_id = this.parentNode.parentNode.parentNode.id; 
        	show_loader_for_price(document_id);
        	$("select[name*='["+document_id+"][margins]']").load(
        		url_for_load_print_margins, 
        		{order_id: order_id, id: document_id, order_type: 'foto_print'},
        		function(){
        			$(this).attr("disabled",false);
        			$(this).change(); //for update document price
        			validate_documents();
        		}
        		);
        	
        });

        //подключение хендлеров по управлению ценой по состоянию margins 
        $("select[name*='margins']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var document_id = this.parentNode.parentNode.parentNode.id, 
          	  selected_margins = $(this).val(),
          	  selected_paper_size = $("select[name*='["+document_id+"][paper_size]']").val(),
          	  selected_paper_type = $("select[name*='["+document_id+"][paper_type]']").val(),
          	  selected_quantity = $("input[name*='["+document_id+"][quantity]']").val();
          	  
          show_loader_for_price(document_id);
          $.post( url_for_update_document, 
          	{id: document_id, paper_size: selected_paper_size, paper_type: selected_paper_type, margins: selected_margins, quantity: selected_quantity, order_type: 'foto_print'},
          	function() {
          	   hide_loader_for_price(document_id);
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 	);
        });
        
		//change handler for quantity with debounce (if user click many times)
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
          var selected_quantity = $(this).val(),
              document_id = this.parentNode.parentNode.parentNode.id;
          
          selected_quantity = validate(parseInt(selected_quantity));
          $(this).val(selected_quantity);
          
		  $.ajax({
			type: 'POST',
			url: url_for_update_document,
			beforeSend: show_loader_for_price(document_id),
			data: {id: document_id, quantity: selected_quantity},
			success: function() {
			       	   hide_loader_for_price(document_id);
			           $.post( url_for_update_order, {id: order_id} );
  					 }
			});
        }));

		//change handler for pre_print_operations with debounce (if user click many times)
        $("input[name*='pre_print_operation']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', jQuery.debounce( 0, function(event){
          if ($(this).is(':checked')) {
          	var check_status = 1;
          } else {
          	var check_status = 0;
          }
            var document_id = this.parentNode.parentNode.parentNode.id,
            	pre_print_operation_id = $(this).val();
                  
			  $.ajax({
				type: 'POST',
				url: url_for_update_document,
				beforeSend: show_loader_for_price(document_id),
				data: {id: document_id, pre_print_operation: pre_print_operation_id, check_status: check_status},
				success: function() {
				       	   hide_loader_for_price(document_id);
				           $.post( url_for_update_order, {id: order_id} );
	  					 }
				});
        }));

        //обновление цены после удаления одного документа
        $("a.link_delete_docfile:not([handler-status='with_priceEventHandler'])").attr('handler-status', 'with_priceEventHandler').bind('click', function(event){
          setTimeout(function(){$.post(url_for_update_order, {id: order_id} );}, 1000);
          setTimeout(function(){validate_documents()}, 1000);
        });

        //работа переключателя количества файлов
        $("button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) + 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });
        $("button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) - 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });

        //проверка значения количества файлов для печати
        function validate(value){
          if (value < 1 || isNaN(value) == true) {
            value = 1;
          } else if (value > 999) {
            value = 999;
          }
          return value;
        };
        

		//time
        $('#timepicker_start').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:00', 'maxTime': '23:30' });
        $('#timepicker_end').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:30', 'maxTime': '00:00' });
    	
        //cчитаем кол-во документов в форме
        function validate_documents(){
        	var quantity_documents = $("tr.document").length;
        	if (quantity_documents == 0){
        		$("input#quantity_documents_for_validate").val('');
        	} else {
        		$("input#quantity_documents_for_validate").val(quantity_documents);
        	}
        };

        //устанавливаем css аниматор загрузки цены
        function show_loader_for_price(document_id){
        	$("table#fileList tr#"+document_id+" td.document_cost .document_cost_value").hide();
        	$("table#fileList tr#"+document_id+" td.document_cost .floatingBarsG").show();
        };
        
        function hide_loader_for_price(document_id){
        	var loader = $("table#fileList tr#"+document_id+" td.document_cost .floatingBarsG"),
        		price = $("table#fileList tr#"+document_id+" td.document_cost .document_cost_value");

	        	price.show();
	        	loader.hide();       		
        };
        
    }

  });

