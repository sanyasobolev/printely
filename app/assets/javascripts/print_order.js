$(document).ready(function(){
    if($(".edit_print_order").exists()) {
        //контроль ухода пользователя со страницы
        $(".edit_print_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style, a.link_delete_docfile"
        });

        //clear value 'выберите' in select
        $("select#order_delivery_street").change(function(event){
            $('[value=""]',event.target).remove();
        });
        
        //client validator
        $("form.edit_print_order").validate({
        	ignore: "",
    		rules: {
    			'order[delivery_address]': "required",
    			'order[delivery_street]':"required",
    			'order[delivery_date]':"required",
    			'quantity_documents_for_validate':"required"
    		},
    		messages: {
    			'order[delivery_address]': "?",
    			'order[delivery_street]':"?",
    			'order[delivery_date]':"?",
    			'quantity_documents_for_validate':"Загрузите файлы."
    		}
    		}
        );

		
        var order_id = $("form.edit_print_order").attr("id"),
            url_for_update_order = "/order/ajaxupdate",
            url_for_update_document = "/document/price_update",
            url_for_load_paper_sizes = "/document/get_paper_sizes",
            url_for_load_paper_types = "/document/get_paper_types",
            url_for_load_print_margins = "/document/get_print_margins";

        //при любом изменении в таблице, устанавливаем тип доставки "курьер"
        $("table.order_delivery").change(function(event){
            var selected_delivery = 'Курьер';
            $.post( url_for_update_order, {id: order_id, delivery_type: selected_delivery} );
        });
            
        //подключение хендлеров по управлению ценой (при уже загруженных документах - в случае рефреша страницы)
		//есть ли уже установленные значения списков
		

         //load paper_sizes------------------------------------------------------------------------------------
        $("select[name*='paper_size']:not([class='with_loaded_paper_sizes'])").addClass("with_loaded_paper_sizes").load(url_for_load_paper_sizes, function(){$(this).change();});

        //change handler for load paper_types
        $("select[name*='paper_size']").change(function(event){
        	var selected_paper_size = $(this).val(),
        	document_id = this.parentNode.parentNode.id;
        	$("select[name*='["+document_id+"][paper_type]']").load(
        		url_for_load_paper_types, 
        		{selected_paper_size: selected_paper_size},
        		function(){
        			$(this).attr("disabled",false);
        			$("select[name*='["+document_id+"][margins]']").attr("disabled",false);
        			$(this).change();
        		}
        		);
        	
        });


        //change handler for load print margins
        $("select[name*='paper_type']").change(function(event){
        	var document_id = this.parentNode.parentNode.id, 
        	selected_paper_type = $(this).val(),
        	selected_paper_size = $("select[name*='["+document_id+"][paper_size]']").val();
        	$("select[name*='["+document_id+"][margins]']").load(
        		url_for_load_print_margins, 
        		{selected_paper_size: selected_paper_size, selected_paper_type: selected_paper_type},
        		function(){
        			$(this).attr("disabled",false);
        			$(this).change(); //for update document price
        			validate_documents();
        		}
        		);
        	
        });

        //подключение хендлеров по управлению ценой по состоянию margins 
        $("select[name*='margins']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var document_id = this.parentNode.parentNode.id, 
          	  selected_margins = $(this).val(),
          	  selected_paper_size = $("select[name*='["+document_id+"][paper_size]']").val(),
          	  selected_paper_type = $("select[name*='["+document_id+"][paper_type]']").val();
          	  selected_quantity = $("input[name*='["+document_id+"][quantity]']").val();
          $.post( url_for_update_document, 
          	{id: document_id, paper_size: selected_paper_size, paper_type: selected_paper_type, margins: selected_margins, quantity: selected_quantity},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 	);
        });
        
		//change handler for quantity
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var selected_quantity = $(this).val(),
              document_id = this.parentNode.parentNode.id;
          selected_quantity = validate(parseInt(selected_quantity));
          $(this).val(selected_quantity);
          $.post( url_for_update_document, 
          	{id: document_id, quantity: selected_quantity},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	);
        });


        //обновление цены после удаления одного документа
        $("a.link_delete_docfile:not([handler-status='with_priceEventHandler'])").attr('handler-status', 'with_priceEventHandler').bind('click', function(event){
          setTimeout(function(){$.post(url_for_update_order, {id: order_id} );}, 1000);
          setTimeout(function(){validate_documents()}, 1000);

        });

        //работа переключателя количества файлов
        $("button.increase:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) + 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });
        $("button.decrease:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
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
        
        //cчитаем кол-во документов в форме
        function validate_documents(){
        	var quantity_documents = $("tr.document").length;
        	if (quantity_documents == 0){
        		$("input#quantity_documents_for_validate").val('');
        	} else {
        		$("input#quantity_documents_for_validate").val(quantity_documents);
        	}
        };

		//time
        $('#timepicker_start').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:00', 'maxTime': '23:30' });
        $('#timepicker_end').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:30', 'maxTime': '00:00' });
    }
  });

