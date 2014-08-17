$(document).ready(function(){
	if(($(".edit_letter_print_order").exists()) || ($(".admin_letter_print_order").exists())) {

        var url_for_update_order = "/order/ajaxupdate",
            url_for_update_document = "/document/price_update",
            url_for_load_paper_sizes = "/document/get_paper_sizes",
            url_for_load_paper_types = "/document/get_paper_types",
            url_for_load_layout = "/document/get_layout";
    
    if($(".edit_letter_print_order").exists()) {
    	
    	var order_id = $("form.edit_letter_print_order").attr("id");
    	
        //контроль ухода пользователя со страницы
        $(".edit_letter_print_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style, a.no_confirm"
        });
        
        //client validator
        $("form.edit_letter_print_order").validate({
        	ignore: "",
    		rules: {
    			'order[delivery_address]': "required",
    			'order[delivery_town_id]':"required",
    			'order[delivery_date]':"required"
    		},
    		messages: {
    			'order[delivery_address]': "?",
    			'order[delivery_town_id]':"?",
    			'order[delivery_date]':"?"
    		}
    		});
    }//end edit_foto_print_order

                 
        //подключение хендлеров 

        //load paper_sizes------------------------------------------------------------------------------------
        $("select[name*='paper_size']").on("load_sizes", function(event) {
        	var document_id = this.parentNode.parentNode.parentNode.id;
        	$(this).load(
	     		url_for_load_paper_sizes, 
	        	{order_id: order_id, id: document_id, order_type: 'letter_print'},
	        	function(){
	        		$(this).change();
	        		});        	
        	});
		$("select[name*='paper_size']:not([class*='with_loaded_paper_sizes'])").addClass("with_loaded_paper_sizes").trigger("load_sizes");
 
		
        //change handler for load paper_types
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").change(function(event){
        	var selected_paper_size = $(this).val(),
        	document_id = this.parentNode.parentNode.parentNode.id;
        	//show_loader_for_price(document_id);
        	$("select[name*='["+document_id+"][paper_type]']").load(
        		url_for_load_paper_types, 
        		{selected_paper_size: selected_paper_size, order_id: order_id, id: document_id, order_type: 'letter_print', with_density: 1 },
        		function(){
        			$(this).attr("disabled",false);
        			//$("select[name*='["+document_id+"][margins]']").attr("disabled",false);
        			$(this).change();
        		}
        		);
        	
        });
        
        //change handler for load layout
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
        	var document_id = this.parentNode.parentNode.parentNode.id,
        	    selected_paper_type = $(this).val(),
        	    selected_paper_size = $("select[name*='["+document_id+"][paper_size]']").val();
        	//show_loader_for_price(document_id);
        	$("div#canvas_bg").load(
        		url_for_load_layout, 
        		{order_id: order_id, id: document_id, selected_paper_type: selected_paper_type, selected_paper_size: selected_paper_size},
        		function(){
        			$(this).change(); //for update document price
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

        //работа переключателя количества файлов
        $("button.increase_quantity_large:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) + 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });
        $("button.decrease_quantity_large:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
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
          } else if (value > 1000) {
            value = 1000;
          }
          return value;
        };
        
        //create tabs
        $('#tab-container').easytabs({
			  updateHash: false
        });
		//----------------------------------------------------------------------------------------------------

		//canvas-------------------------------------------------------------------------------------------------
		var canvas = new fabric.Canvas("canvas");
		canvas.setWidth(545);
		canvas.setHeight(385);
		//--------------------------------------------------------------------------------------------------------

        
        //sidebar---------------------------------------------------------------------------
		//text
		var MaxTextInputs       = 5; //maximum input boxes allowed
		var TextInputsWrapper   = $("#text_inputs_wrapper"); //Input boxes wrapper ID
		var AddButton           = $("#add_text"); //Add button ID
		
		var x = TextInputsWrapper.length; //initial text box count
		var FieldCount=0; //to keep track of text box added
		
		$(AddButton).click(function (e)  //on add input button click
		{
		        if(x <= MaxTextInputs) //max input box allowed
		        {
		            FieldCount++; //text box added increment
		            //add input box
		            $(TextInputsWrapper).append('<div><input type="text" name="text_'+ FieldCount +'" class="text_field" id="text_'+ FieldCount +'" value="Текст '+ FieldCount +'"/><button class="remove_element" name="button" type="button"><img src="/assets/icons/del-3.png" alt="Del-3"></button></div>');
		           	//add text to canvas
		           	canvas_text=new fabric.Text('Текст '+FieldCount, {
			           top:Math.floor(Math.random()*350+1),
			           left:Math.floor(Math.random()*250+1),
			           fill:'red'
			        });
			        canvas_text.set('itemId', 'text_' +FieldCount);
			        canvas.add(canvas_text);	            		            
		            x++; //text box increment
		        }
				return false;
		});
		
		$("body").on("click", ".remove_element", function(e){ //user click on remove text
		        if( x > 0 ) {
		        	var sidebar_textId = $(this).siblings("input[id*='text']").attr('id');
		                $(this).parent('div').remove(); //remove text box		   
		                canvas_text = canvas.getItemById(sidebar_textId);
		                canvas.remove(canvas_text);
     					canvas.renderAll();
		                x--; //decrement textbox
		        }
		return false;
		});
		
		$("body").on("keyup",".text_field", function(e){ //user change text
			var sidebar_text = $(this).val(),
				sidebar_textId = $(this).attr('id');
			canvas_item = canvas.getItemById(sidebar_textId);
			canvas_item.set({ text: sidebar_text }); 
			canvas.renderAll();
		return false;
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

