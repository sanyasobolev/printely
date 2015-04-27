$(document).ready(function() {
	
 	var  form = $("form");

	//определяем объекты
	var order = {
		order_id: form.attr("id"),
		order_type: 'envelope_print',
		url_for_update_documents_price: "/order/set_documents_price",
		url_for_submit_order: "/order_steps/documents",
		quantity_step: 1,
		quantity_min_value: 1,
		quantity_max_value: 1000
	};
		
	var envdocument = {
		document_id: $('table#fileList tr.document').attr("id"),
		url_for_create_document: url_for_create_document,
		url_for_create_emb_images: $('input#embedded_image_imgfile').attr('rel'),
		url_for_update_document: "/document/price_update",
        url_for_load_paper_sizes: "/document/get_paper_sizes",
        url_for_load_paper_types: "/document/get_paper_types",
		url_for_load_layout: "/paper_specification/get_layout", 
		url_for_load_canvas_settings: "/paper_specification/get_canvas_settings",
	};

	var progress = {
		panel: false,
		label: $('.progress-label'),
		state: false,
	};	
	
    //контроль ухода пользователя со страницы
    form.FormNavigate({
       message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
       aOutConfirm: "input.button_style, a.no_confirm"
    });
    
         //load paper_types for event change paper_size
        //paper sizes load after load fabric
        $("select[name*='paper_size']:not([class*='with_bind_change_event'])").addClass("with_bind_change_event").on("change", function(event){
          	envdocument.document_id = $('table#fileList tr.document').attr("id");
        	envdocument.selected_paper_size = $(this).val();
        	uploadfn.show_loader_for_div("order_documents_price_value");
        	uploadfn.loadPaperTypes(envdocument, order);
        });

		//load layout, canvas and calculate price for document for event change paper type
		$("select[name*='paper_type']:not([class*='with_loaded_paper_types'])").addClass("with_loaded_paper_types").on("change", function(event) {
			envdocument.document_id = $('table#fileList tr.document').attr("id"), 
			envdocument.selected_paper_type = $(this).val(), 
			envdocument.selected_paper_size = $("select[name*='["+envdocument.document_id+"][paper_size]']").val();
  			envdocument.selected_quantity = $("input[name*='["+envdocument.document_id+"][quantity]']").val();

			editorfn.loadCanvasLayout(envdocument, order);
			editorfn.getCanvasSettings(envdocument, canvas);
			uploadfn.show_loader_for_div("order_documents_price_value");
            uploadfn.calculateDocumentAndOrderPrice(envdocument, order);
            
		});		

		//change handler for quantity with debounce (if user click many times)       
        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', jQuery.debounce( 750, function(event){
        	envdocument.document_id = $('table#fileList tr.document').attr("id");
			envdocument.selected_quantity = $(this).val(uploadfn.validate_quantity(parseInt($(this).val()), parseInt(order.quantity_min_value), parseInt(order.quantity_max_value))).val(); //проверка введенного числа и запись его в document object
			
			uploadfn.show_loader_for_div("order_documents_price_value");
       		uploadfn.calculateDocumentAndOrderPrice(envdocument, order);
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

		
		//top toolbar-------------------------------------------------------------------
		var top_toolbar = $("div.top_toolbar"),
			
			font_family_tool = {
				container: $(".font_family_tool"),
				picker: $("#font_family_picker"),				
			};
			
			color_tool = {
				container: $(".color_tool"),
			};
			
			font_style_tool = {
				container: $('.font_style_tool'),
				font_weight_button: $("#font_weight"),
				font_style_button: $("#font_style"),	
			};

			//первичная инициализация
			//т.к. если его создавать после загрузки fabric - оно не работает
			
			//add font_family_tool
			editorfn.addFontFamilyPicker(null, null, font_family_tool, font_style_tool); 
			
			//add color_tool
			editorfn.addColorPicker(color_tool);
			
			//add events fontstyle tool
			editorfn.addEventHandlersToButtons(null, null);
	
			//$(top_toolbar).hide();
	
		//sidebar---------------------------------------------------------------------------
		//add, remove and update text
		var max_text_inputs = 10, //maximum input boxes allowed
			text_inputs_wrapper = $("table#text_inputs_wrapper"), //Input boxes wrapper ID
			x = $("table#text_inputs_wrapper tr").length, //initial text box count
			field_count = 0;//to keep track of text box added

		$("#add_text").click(function()//on add input button click
		{
			if (x < max_text_inputs)//max input box allowed
			{
				field_count++;//text box added increment
				//add input box
				editorfn.addTextInput(text_inputs_wrapper, field_count);
				//add text to canvas
				canvasfn.addTextToCanvas(sidebar_text_value, sidebar_text_id, canvas);
				x++;//text box increment
			}
			return false;
		});


		$("body").on("click", ".remove_element", function() {//user click on remove element
			if (x > 0) {
				var sidebar_text_id = 'text_'+$(this).parent().parent().attr('id');
				$(this).parent().parent('.embedded_text').remove();//remove text tr
				canvasfn.RemoveObjectFromCanvas(sidebar_text_id, canvas);
				x--;//decrement textbox
			}
			return false;
		});

		$("body").on("keyup", ".text_field", function() {//user change text
			var sidebar_text_value = $(this).val(), 
				sidebar_text_id = $(this).attr('id');
			canvasfn.UpdateTextOnCanvas(sidebar_text_id, sidebar_text_value, canvas);
			return false;
		});
		
		$("body").on("focus", ".text_field", function() { //set cursor to input text
		  var elem = $(this);
		  
		  editorfn.unHighlightAll();

	      //highlight selected input
		  setTimeout(function() {
		  	elem.parent().parent().toggleClass( "selected", elem.is( ":focus" ) );
		  	
		  }, 0 );
		  
		  //select object on canvas
		  var canvas_object = canvas.getObjectById($(this).attr('id'));
		  canvas.setActiveObject(canvas_object,onObjectSelected);
		  
		  return false;
		});

	
		//add and remove image
    
	    $('input#embedded_image_imgfile').uploadify({
	      uploader : uploader,
	      buttonImg : buttonImg,
	      script : envdocument.url_for_create_emb_images,
	      fileDataName : 'embedded_image[imgfile]',
	      fileDesc : 'Images (.jpg, .png)',
	      fileExt : '*.png;*.jpg;*.JPG;',
	      sizeLimit : 10240000, //10mb
	      cancelImg : cancelImg,
	      multi : true,
	      scriptData : upload_params,
	      auto : true,
	      onError: function(event, ID, fileObj, errorObj){
		    var queue_error_container = $("#embedded_image_imgfileQueue"),
		    	file_queue_id = $("div#embedded_image_imgfile"+ID+"");
		    uploadfn.error_notification(errorObj, queue_error_container, file_queue_id);      
	      },
	      onSelectOnce : function(queue) { //определяем колво выбранных файлов
		       	progress.state = true;
		       	uploadfn.progress_observer(progress, 0, 'Грузим файлы...'); 		
		  },
	      onComplete : function(e, id, obj, response, data) {
	      	//add images to sidebar
	      	$(response).appendTo('#embedded_fileList');
	      	//add image to canvas
			canvasfn.addImageToCanvasFromURL($("span[id*=image]", response), canvas);
	       },
	      onAllComplete : function(){
	        progress.state = false;
	      	uploadfn.progress_observer(progress, 0, 'Готово.');
	      }	       
		});
		
		$("body").on("click", ".emb_image_delete", function() {//user click on remove element
				var sidebar_image_id = "image_"+this.parentNode.parentNode.id;
				canvasfn.RemoveObjectFromCanvas(sidebar_image_id, canvas);
			//return false;//иначе не работает удаление файла
		});

		$("body").on("click", ".embedded_thumb", function() {//user click on thumb
			var elem = $(this), 
			sidebar_image_id = "image_"+elem.parent().attr('id');
				
			editorfn.unHighlightAll();

	      	//highlight selected image
		  	setTimeout(function() {
		  		elem.parent().toggleClass( "selected", elem.is( ":not([class='selected'])" ) );	
		  	}, 0 );

			//select object on canvas
			var canvas_object = canvas.getObjectById(sidebar_image_id);
			canvas.setActiveObject(canvas_object, onObjectSelected);		  	

			return false;
		});	

	//---------------------------------------------------------------------

	//create png and svg file-------------------------------------------
	form.submit(function(event)
		{
			var $form = $(this);
			envdocument.document_id = $('tr.document').attr("id");

			$form.unbind();
			$("input.submit").disableButton("Переходим...");
			form_data_svg = editorfn.createFormDataSVGFromCanvas(canvas, envdocument);
			form_data_image = editorfn.createFormDataImageFromCanvas(canvas, envdocument);

			//send svg file to server
			$.ajax({
			     url: envdocument.url_for_create_document,
			     type: "POST",
			     data: form_data_svg,
			     processData: false,
			     contentType: false,
			     complete: function(){
					//send image file to server
					$.ajax({
					     url: envdocument.url_for_create_document,
					     type: "POST",
					     data: form_data_image,
					     processData: false,
					     contentType: false,
					     complete: function(){
						 	$form.submit();
					     }
				 		});	
			     }
		 		});	
		 		return false;
		}
	);	

    //-------------------------------------------------------------------


	//load fabric-------------------------------------------------------------------------------------
    (function(){
		var load_fabric_script = document.createElement("script");
		    load_fabric_script.type = "text/javascript";
		    load_fabric_script.async = true;
		    load_fabric_script.src = "/assets/fabric/fabric.js";
		    $("head").append(load_fabric_script);
		    console.log('fabric loaded');
	})();
	
	//----------------------------------------------------------------------------------------------------

  	//create canvas-------------------------------------------------------------------------------------------------
	var canvas = new fabric.Canvas("canvas");
	
	//--------------------------------------------------------------------------------------------------------


	//initialize load paper size-------------------------------------------
	uploadfn.loadPaperSizes(envdocument, order);
    //-------------------------------------------------------------------
    
	//canvas events
	canvas.on('object:selected', onObjectSelected);
	canvas.on('before:selection:cleared', allControlsUnBind);

	function onObjectSelected(options){ //options - selected object
		allControlsUnBind(options); //unbind all controls from other elements
	   	   	    
	    switch(options.target.get('type')){
	    	case 'text':
	   			$(top_toolbar).show();
	    		console.log('selected ' +options.target.get('type'));
	    		console.log('selected ' +options.target.get('ObjectId'));
	    		
	    		//highlight sidebar text element and set current tab
	    		editorfn.highlightElement(options.target.get('ObjectId'), "#tab_2");
	    		
			    //configure colorpicker
			    color_tool.container.show();
			    $.minicolors.defaults.defaultValue = options.target.get('fill');
			    $('#colorpicker').minicolors({
				    change: function(){
				    	console.log('selected color ' +this.value);
				    	options.target.set({fill: this.value});
		    			canvas.renderAll();
				    }
				});
				//configure font family picker
				font_family_tool.container.show();
				editorfn.addFontFamilyPicker(options, canvas, font_family_tool, font_style_tool);
				
				//configure font style picker
				editorfn.addFontStylePicker(options, canvas, font_style_tool);
	    	break;
	    	case 'image':
	    		editorfn.highlightElement(options.target.get('ObjectId'), "#tab_1");
	    	break;
	    }
	    	
	};
	
	function allControlsUnBind(){
		$(top_toolbar).hide();
		
		//unhighlight all elements in sidebar
	    editorfn.unHighlightAll();
	    				
		//destroy colorpicker, because unbind not work
		editorfn.destroyColorPicker(color_tool);

    	//unbind font_family picker
    	editorfn.destroyFontFamilyPicker(font_family_tool);

    	//unbind font_style picker
    	editorfn.destroyFontStylePicker(font_style_tool);
	   	
    	};

	});

