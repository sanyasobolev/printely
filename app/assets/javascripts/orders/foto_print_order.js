$(document).ready(function(){

    if($("form.new_foto_print_order").exists()) {
		var  form = $("form.new_foto_print_order");
    };
    
    if($("form.admin_foto_print_order").exists()) {
		var  form = $("form.admin_foto_print_order");
    };

    var url = $('input#document_docfile').attr('rel');

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
		order_type: 'foto_print',
		url_for_update_order: "/order/ajaxupdate",
		quantity_step: 1,
		quantity_min_value: 1,
		quantity_max_value: 1000
	};
		
	var document = {
		url_for_update_document: "/document/price_update",
        url_for_load_paper_sizes: "/document/get_paper_sizes",
        url_for_load_paper_types: "/document/get_paper_types",
        url_for_load_print_margins: "/document/get_print_margins",
        queue_files_count: 0
	};
	
    $('input#document_docfile').uploadify({
      uploader : uploader,
      buttonImg : buttonImg,
      script : url,
      fileDataName : 'document[docfile]',
      fileDesc : 'Images (.jpg, .png)',
      fileExt : '*.png;*.jpg;*.JPG;',
      sizeLimit : 102400, //10MB
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
		uploadfn.progress_observer(progress, 50/document.queue_files_count, 'Грузим файлы...');
       },
      onAllComplete : function(){
        
      	uploadfn.progress_observer(progress, 0, 'Считаем стоимость...');
        
        //load paper_sizes------------------------------------------------------------------------------------
		uploadfn.loadPaperSizes(document, order);

        //load paper_types for event change paper_size
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").change(function(event){
          	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_size = $(this).val();
        	uploadfn.loadPaperTypes(document, order);
        });

        //load print margins for event change paper_type
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
    	    document.document_id = this.parentNode.parentNode.parentNode.id; 
	       	document.selected_paper_type = $(this).val();
        	uploadfn.loadPrintMargins(document, order);
        });

        //calculate price for document for event change print margin
        $("select[name*='margins']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          document.document_id = this.parentNode.parentNode.parentNode.id;
		  document.selected_paper_size = $("select[name*='["+document.document_id+"][paper_size]']").val();
		  document.selected_paper_type = $("select[name*='["+document.document_id+"][paper_type]']").val();
		  document.selected_print_margins = $(this).val();
		  document.selected_quantity = $("input[name*='["+document.document_id+"][quantity]']").val();

          uploadfn.calculateDocumentAndOrderPrice(document, order);
        });
        
		//change handler for quantity with debounce (if user click many times)       
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
			document.selected_quantity = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); //проверка введенного числа и запись его в document object
				
       		uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));
        
        //работа переключателя количества копий
        $("button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_increase(selected_input_quantity, order.quantity_step, order.quantity_max_value);
        });

        $("button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_decrease(selected_input_quantity, order.quantity_step, order.quantity_min_value);
        });
          
		//change handler for pre_print_operations with debounce (if user click many times)
        $("input[name*='pre_print_operation']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', jQuery.debounce( 0, function(event){
          if ($(this).is(':checked')) {
          	document.pre_print_operation_check_status = 1;
          } else {
          	document.pre_print_operation_check_status = 0;
          }
            document.document_id = this.parentNode.parentNode.parentNode.id,
            document.pre_print_operation = $(this).val();
            
            uploadfn.calculateDocumentAndOrderPrice(document, order);   
        }));

	    }
    });
	
    //clear value 'выберите' in select
	deliveryfn.clear_select();
	
	//timepicker
	deliveryfn.delivery_timepicker();

    //контроль ухода пользователя со страницы
    form.FormNavigate({
       message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
       aOutConfirm: "input.button_style, a.link_delete"
    });
        
    //client validator
    form.validate({
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
                  
        //подключение хендлеров по управлению ценой (при уже загруженных документах - в случае рефреша страницы)

        //load paper_sizes------------------------------------------------------------------------------------
		uploadfn.loadPaperSizes(document, order);
		
        //load paper_types for event change paper_size
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").on("change", function(event){
          	document.document_id = this.parentNode.parentNode.parentNode.id;
        	document.selected_paper_size = $(this).val();
        	uploadfn.loadPaperTypes(document, order);
        });


        //load print margins for event change paper_type
        $("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").change(function(event){
    	    document.document_id = this.parentNode.parentNode.parentNode.id; 
	       	document.selected_paper_type = $(this).val();
        	uploadfn.loadPrintMargins(document, order);
        });


        //calculate price for document for event change print margin
        $("select[name*='margins']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          document.document_id = this.parentNode.parentNode.parentNode.id;
		  document.selected_paper_size = $("select[name*='["+document.document_id+"][paper_size]']").val();
		  document.selected_paper_type = $("select[name*='["+document.document_id+"][paper_type]']").val();
		  document.selected_print_margins = $(this).val();
		  document.selected_quantity = $("input[name*='["+document.document_id+"][quantity]']").val();

          uploadfn.calculateDocumentAndOrderPrice(document, order);
        });
        
		//change handler for quantity with debounce (if user click many times)       
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	document.document_id = this.parentNode.parentNode.parentNode.id;
			document.selected_quantity = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); //проверка введенного числа и запись его в document object
				
       		uploadfn.calculateDocumentAndOrderPrice(document, order);
        }));
        
        //работа переключателя количества копий
        $("button.increase_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_increase(selected_input_quantity, order.quantity_step, order.quantity_max_value);
        });

        $("button.decrease_quantity:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
        	var selected_input_quantity = $(this).siblings("input[id*='quantity']");
        	uploadfn.button_decrease(selected_input_quantity, order.quantity_step, order.quantity_min_value);
        });
          
		//change handler for pre_print_operations with debounce (if user click many times)
        $("input[name*='pre_print_operation']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', jQuery.debounce( 0, function(event){
          if ($(this).is(':checked')) {
          	document.pre_print_operation_check_status = 1;
          } else {
          	document.pre_print_operation_check_status = 0;
          }
            document.document_id = this.parentNode.parentNode.parentNode.id,
            document.pre_print_operation = $(this).val();
            
            uploadfn.calculateDocumentAndOrderPrice(document, order);   
        }));
  });

