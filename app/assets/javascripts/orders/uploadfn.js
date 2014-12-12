(function () {
    // Initialize namespace (or use existing one if present)
    window.uploadfn = window.uploadfn || {};

    // Add function  to the namespace
    
    //error notification function for uploadify
    uploadfn.error_notification = function(errorObj, queue_error_container, file_queue_id){
	    //определяем тип ошибки
	    switch(errorObj.type) {
	         case "File Size":
	             error_type = "Слишком большой файл.";
	             error_desc = "Максимальный размер не более "+parseInt(errorObj.info)/1024000+"Мб.";
	             break;
	         default:
	             error_type = "Что-то пошло не так.";
	             error_desc = "Сообщите нам об этой ошибке - мы постараемся ее исправить.";
	             break;
	    };
	    
	    //добавляем описание ошибки
	    file_queue_id.append("<span class='uploadify_error_ru'> - "+error_type+" "+error_desc+"</span>");
		
		//добавляем кнопку очистки и header, если их нет
		if(!$("button#clear_queue").exists()) {
      	var	clear_errors_button = '<button class="link_delete" id="clear_queue" name="button" type="button"><img alt="Del-3" src="/assets/icons/del-3.png"></button>',
      		queue_error_header = '<div class="uploadifyQueueHeader">Следующие файлы не были загружены:</div>';
	      	queue_error_container.prepend(queue_error_header);
	      	queue_error_container.prepend(clear_errors_button);
	      	$("body").on("click", "button#clear_queue",  function(){
	      		queue_error_container.css("display", "none");
	      		queue_error_container.empty();
	      		}
	      	);	
	      	
      	};
      	queue_error_container.css("display", "block");//делаем видимым сообщение об ошибке
    };
    
    //progress observer
    uploadfn.progress_observer = function(progress, step, label){
       	switch(progress.panel){
       		case false: //случай, когда отображаем только label
       			if(progress.state==false){
       				progress.label.css("display", "none");
       			} else {
       				progress.label.html(label);
       				progress.label.css("display", "block");
       			}
       		break;
       		default:
		       	next_value = progress.bar.val() + step;
		       	progress.bar.val(next_value);
		       	progress.value.html(Math.round(next_value) + '%');       		
		       	
		       	if(progress.state==false){
		       		progress.panel.css("display", "none");		
		       	} else {
			       	if($("table#fileList tr.document").exists() && $("table#fileList tr.document:not(.calculated)").length == 0) { //если все загрузилось
			       		progress.panel.css("display", "none");
			       		progress.label.html('success');
			       		uploadfn.show_fileListHeader();
			       		uploadfn.show_all_documents();
			       	}
			       	else{
			       		progress.panel.css("display", "block");
			       		progress.label.html(label);
			       	} 
		       	}
       		break;
       	}
    };
    
    
    //cчитаем кол-во документов в форме
    uploadfn.calculate_documents = function(){
        	var quantity_documents = $("tr.document").length;
        	if (quantity_documents == 0){
        		$("input#quantity_documents_for_validate").val('');
        	} else {
        		$("input#quantity_documents_for_validate").val(quantity_documents);
        	}
        };
    
    //устанавливаем css аниматор загрузки цены
    uploadfn.show_loader_for_price = function (document_id){
    	//console.log('do show loader for '+document_id);
      	$("table#fileList tr#"+document_id+" td.document_cost .document_cost_value").hide();
       	$("table#fileList tr#"+document_id+" td.document_cost .floatingBarsG").show();
    };
        
    uploadfn.hide_loader_for_price = function (document_id){
       	var loader = $("table#fileList tr#"+document_id+" td.document_cost .floatingBarsG"),
       		cost = $("table#fileList tr#"+document_id+" td.document_cost .document_cost_value");
			
          	//console.log('do hide loader for '+document_id);
        	cost.show();
        	loader.hide();       		
     };
    
    //load paper sizes
    uploadfn.loadPaperSizes = function (document, order) {
    	$("select[name*='paper_size']").on("load_sizes", function(event) {
        	document_id = this.parentNode.parentNode.parentNode.id; 
        	$(this).load(
	     		document.url_for_load_paper_sizes, 
	        	{
	        		order_id: order.order_id, 
	        		id: document_id, 
	        		order_type: order.order_type
	        		},
	        	function(){
	        		$(this).change();
	        		});
        	});
		$("select[name*='paper_size']:not([class*='with_loaded_paper_sizes'])").addClass("with_loaded_paper_sizes").trigger("load_sizes");
     };
    
    //load paper types
    uploadfn.loadPaperTypes = function (document, order){
        	//console.log('loadpapertypes' +document.document_id);
        	uploadfn.show_loader_for_price(document.document_id);
        	$("select[name*='["+document.document_id+"][paper_type]']").load(
        		document.url_for_load_paper_types, 
        		{
        			selected_paper_size: document.selected_paper_size, 
        			order_id: order.order_id, 
        			id: document.document_id, 
        			order_type: order.order_type
        		},
        		function(){
        			$(this).attr("disabled",false);
        			//$("select[name*='["+document.document_id+"][margins]']").attr("disabled",false);
        			$(this).change();
        		}
        		);
    };
    
    //load print margins
    uploadfn.loadPrintMargins = function (document, order){
        	uploadfn.show_loader_for_price(document.document_id);
        	$("select[name*='["+document.document_id+"][margins]']").load(
        		document.url_for_load_print_margins, 
        		{
        			order_id: order.order_id, 
        			id: document.document_id, 
        			order_type: order.order_type
        			},
        		function(){
        			$(this).attr("disabled",false);
        			$(this).change(); //for update document price
        			uploadfn.calculate_documents();
        		}
        		);
    };
    
    //load print colors
    uploadfn.loadPrintColors = function (document, order){
        	uploadfn.show_loader_for_price(document.document_id);
        	$("select[name*='["+document.document_id+"][print_color]']").load(
        		document.url_for_load_print_colors, 
        		{
        			order_id: order.order_id, 
        			id: document.document_id, 
        			order_type: order.order_type
        			},
        		function(){
        			$(this).attr("disabled",false);
        			$(this).change(); //for update document price
        			uploadfn.calculate_documents();
        		}
        		);
    };
    
    //load canvas layout
    uploadfn.loadLayout = function (document, order){
		$("div#canvas_bg").load(
			document.url_for_load_layout, 
			{
				order_id : order.order_id,
				id : document.document_id,
				selected_paper_type : document.selected_paper_type,
				selected_paper_size : document.selected_paper_size
				}, 
			function() {
				$(this).change();
				//for update document price
				});   	
    };
    
    //calculate document and order price
    uploadfn.calculateDocumentAndOrderPrice = function (document, order)
    	{
          uploadfn.show_loader_for_price(document.document_id);
          $.post( document.url_for_update_document, 
	          	{
	          		id: document.document_id, 
	          		pre_print_operation: document.pre_print_operation,
	          		check_status: document.pre_print_operation_check_status,
	          		paper_size: document.selected_paper_size, 
	          		paper_type: document.selected_paper_type, 
	          		print_color: document.selected_print_color,
	          		margins: document.selected_print_margins, 
	          		quantity: document.selected_quantity, 
	          		page_count: document.selected_page_count,
	          		order_type: order.order_type,
	          		queue_files_count: document.queue_files_count
	          	},
	          	function(){
					$.post( order.url_for_update_order, {id: order.order_id} );   	
	          	}			
          	 );
          	 delete document.document_id;
          	 delete document.selected_paper_size;
          	 delete document.selected_paper_type; 
          	 delete document.selected_print_margins;
          	 delete document.selected_quantity; 
          	 delete document.selected_print_color; 
          	 delete document.selected_page_count; 
          	 delete document.pre_print_operation;
          	 delete document.pre_print_operation_check_status;
    };

    //проверка значения количества
    uploadfn.validate_quantity  = function(value, min_value, max_value){
    	if (value < min_value || isNaN(value) == true) {
            value = min_value;
          } else if (value > max_value) {
            value = max_value;
          }
          return value;
     };
    
    //кнопка увеличения копий
    uploadfn.button_increase = function(selected_input_quantity, step, max_value){
          new_value = parseInt(selected_input_quantity.val()) + parseInt(step);
          new_value = uploadfn.validate_quantity(new_value, 0, max_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        };
    
    //кнопка уменьшения копий
    uploadfn.button_decrease = function(selected_input_quantity, step, min_value){
          new_value = parseInt(selected_input_quantity.val()) - parseInt(step) ;
          new_value = uploadfn.validate_quantity(new_value, min_value, 1000);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        };        
        
     //delete error messages
     uploadfn.clear_error_message = function(){
        if ($("label[for='quantity_documents_for_validate']")) {
        	$("label[for='quantity_documents_for_validate']").fadeOut("fast");
        };     	
     };
     
     //create header for table filelist
     uploadfn.show_fileListHeader = function(){
        var status_fileList_header = $("#fileList_header").attr("style");
	    if (status_fileList_header == 'display: none;') {
          $("#fileList_header").fadeIn("slow", function(){
          	$('table#fileList').floatThead({
				floatTableClass: 'floatTheadfileListOrder',
				debounceResizeMs: 100
			});
          });
        }
     };
     
     uploadfn.show_all_documents = function(){
     	$("table#fileList tr.document").prop("style", null).fadeIn("slow");
     };


})();