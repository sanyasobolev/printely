$(document).ready(function(){

	var  form = $("form");

	//определяем объекты
	var progress = {
		panel: $('.progress-panel'),
		bar: $('#progressbar'),
		value: $('.progress-value'),
		label: $('.progress-label'),
		state: false,
	};	
	
	var order = {
		order_id: form.attr("id"),
		order_type: 'doc_print',
		url_for_update_documents_price: "/order/set_documents_price",
		quantity_step: 1,
		quantity_min_value: 1,
		quantity_max_value: 1000
	};
		
	var document = {
		url_for_create_document: url_for_create_document,
		url_for_update_document: "/document/update",
        url_for_load_paper_sizes: "/document/get_paper_sizes",
        url_for_load_paper_types: "/document/get_paper_types",
        url_for_load_print_colors: "/document/get_print_colors",
        queue_files_count: 0
	};

    $('input#document_docfile').uploadify({
      uploader : uploader,
      buttonImg : buttonImg,
      script : document.url_for_create_document,
      fileDataName : 'document[docfile]',
      fileDesc : 'Documents (.pdf, .doc, .docx, .ppt, .pptx)',
      fileExt : '*.doc;*.docx;*.pdf;*.ppt;*.pptx',
      sizeLimit : 10240000, //10MB
      cancelImg : cancelImg,
      multi : true,
      scriptData : upload_params,
      auto : true,
      onError: function(event, ID, fileObj, errorObj){
	    var queue_error_container = $("#document_docfileQueue"),
	    	file_queue_id = $("div#document_docfile"+ID+"");
	    uploadfn.error_notification(errorObj, queue_error_container, file_queue_id);
      },
      onSelectOnce : function(queue) { //определяем колво выбранных файлов и обнуляем progressbar
      	document.queue_files_count = parseInt($('input#document_docfile').uploadifySettings('queueSize'));	
       	if(document.queue_files_count>0){
	       	uploadfn.clear_error_message();//стираем сообщение об ошибке незагруженных файлов
	       	progress.state = true;
	       	progress.bar.val(0);
	       	uploadfn.progress_observer(progress, 0, 'Анализ выбранных файлов...'); 		
       	}
	  },
      onComplete : function(e, id, obj, response, data) {
      	//add and hide documents
      	$(response).hide().appendTo('#fileList');//

		//update progress bar
		uploadfn.progress_observer(progress, 100/document.queue_files_count, 'Грузим файлы...');
       },
      onAllComplete : function(){
        progress.state = false;
      	uploadfn.progress_observer(progress, 0, 'Готово.');
      	uploadfn.show_fileListHeader();
		uploadfn.show_all_documents();

        //update order cost------------------------------------------------------------------------------------
		uploadfn.calculateOrderPrice(order);
		
		//считаем кол-во документов
		uploadfn.calculate_documents();
		
        //load paper_types for event change paper_size
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").change(function(event){
          	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_size = $(this).val();
        	uploadfn.show_loader_for_table(document.document_id);
        	uploadfn.loadPaperTypes(document, order);
        });

        //change handler for load print colors
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_type = $(this).val();
        	uploadfn.show_loader_for_table(document.document_id);
        	uploadfn.loadPrintColors(document, order);     	
        });

        //calculate price for document for event change print color
        $("select[name*='print_color']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          document.document_id = this.parentNode.parentNode.parentNode.id;
		  document.selected_paper_size = $("select[name*='["+document.document_id+"][paper_size]']").val();
		  document.selected_paper_type = $("select[name*='["+document.document_id+"][paper_type]']").val();
		  document.selected_print_color = $(this).val();
		  document.selected_quantity = $("input[name*='["+document.document_id+"][quantity]']").val();

          if ($("input[name*='["+document.document_id+"][page_count]']")){
           	  	document.selected_page_count = $("input[name*='["+document.document_id+"][page_count]']").val();
	       	  } else 
	       	  {
	          	document.selected_page_count = false;
          	  };
			
		  uploadfn.show_loader_for_table(document.document_id);
          uploadfn.calculateDocumentAndOrderPrice(document, order);
        });

		//change handler for quantity with debounce (if user click many times)
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.parentNode.id;
			document.selected_quantity = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); //проверка введенного числа и запись его в document object
				
			uploadfn.show_loader_for_table(document.document_id);
       		uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));
        
		//change handler for page_count with debounce (if user click many times)
        $("input[name*='page_count']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
			document.selected_page_count = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); 				
       		
       		uploadfn.show_loader_for_table(document.document_id);
			uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));

        //работа переключателя количества копий
        $("div.quantity button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
            var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_increase(selected_input_quantity, order.quantity_step, order.quantity_max_value);
        });

        $("div.quantity button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_decrease(selected_input_quantity, order.quantity_step, order.quantity_min_value);
        });
        
        //работа переключателя количества страниц в документе
        $("td.page_count button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_page_count = $(this).siblings("input[id*='page_count']");
        	uploadfn.button_increase(selected_input_page_count, order.quantity_step, order.quantity_max_value);
        });
        $("td.page_count button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_page_count = $(this).siblings("input[id*='page_count']");
        	uploadfn.button_decrease(selected_input_page_count, order.quantity_step, order.quantity_min_value);
        });
        
      }
    });

    //контроль ухода пользователя со страницы
    form.FormNavigate({
       message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
       aOutConfirm: "input.button_style, a.link_delete"
    });

    //client validator
    form.validate({
      	ignore: "",
    	rules: {
    		'quantity_documents_for_validate':"required"
    	},
    	messages: {
    		'quantity_documents_for_validate':"Загрузите файлы."
    	},
    	submitHandler: function(form){
    		$("input.submit").disableButton("Переходим...");
    		form.submit();
    	}
    });
    
		//считаем кол-во документов
		uploadfn.calculate_documents();
    
    //подключение хендлеров по управлению ценой (при уже загруженных документах - в случае рефреша страницы)
		
        //load paper_types for event change paper_size
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").change(function(event){
          	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_size = $(this).val();
        	
        	uploadfn.show_loader_for_table(document.document_id);
        	uploadfn.loadPaperTypes(document, order);
        });

        //change handler for load print colors
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_type = $(this).val();
        	
        	uploadfn.show_loader_for_table(document.document_id);
        	uploadfn.loadPrintColors(document, order);     	
        });

        //calculate price for document for event change print margin
        $("select[name*='print_color']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          document.document_id = this.parentNode.parentNode.parentNode.id;
		  document.selected_paper_size = $("select[name*='["+document.document_id+"][paper_size]']").val();
		  document.selected_paper_type = $("select[name*='["+document.document_id+"][paper_type]']").val();
		  document.selected_print_color = $(this).val();
		  document.selected_quantity = $("input[name*='["+document.document_id+"][quantity]']").val();

          if ($("input[name*='["+document.document_id+"][page_count]']")){
           	  	document.selected_page_count = $("input[name*='["+document.document_id+"][page_count]']").val();
	       	  } else 
	       	  {
	          	document.selected_page_count = false;
          	  };

		  uploadfn.show_loader_for_table(document.document_id);
          uploadfn.calculateDocumentAndOrderPrice(document, order);
        });

		//change handler for quantity with debounce (if user click many times)
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.parentNode.id;
			document.selected_quantity = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); //проверка введенного числа и запись его в document object
			
			uploadfn.show_loader_for_table(document.document_id);
       		uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));
        
		//change handler for page_count with debounce (if user click many times)
        $("input[name*='page_count']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
			document.selected_page_count = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); 				
       		
       		uploadfn.show_loader_for_table(document.document_id);
			uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));
        
        //работа переключателя количества копий
        $("div.quantity button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
            var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_increase(selected_input_quantity, order.quantity_step, order.quantity_max_value);
        });

        $("div.quantity button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_decrease(selected_input_quantity, order.quantity_step, order.quantity_min_value);
        });
        
        //работа переключателя количества страниц в документе
        $("td.page_count button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_page_count = $(this).siblings("input[id*='page_count']");
        	uploadfn.button_increase(selected_input_page_count, order.quantity_step, order.quantity_max_value);
        });
        $("td.page_count button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_page_count = $(this).siblings("input[id*='page_count']");
        	uploadfn.button_decrease(selected_input_page_count, order.quantity_step, order.quantity_min_value);
        });

});
