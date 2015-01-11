(function () {
    // Initialize namespace (or use existing one if present)
    window.editorfn = window.editorfn || {};

    // Add function  to the namespace
    
	editorfn.addFontFamilyPicker = function(options, canvas, font_family_tool, font_style_tool){
		font_family_tool.picker.selectmenu({
			width: 210,
			change: function( event, ui ) {
				console.log('selected font ' +ui.item.label);
	    		if (options && canvas) {//if selected object and canvas
	    			options.target.set({fontFamily: ui.item.label});
	    			editorfn.addFontStylePicker(options, canvas, font_style_tool);
	    			canvas.renderAll();
	    		}
			}
		});
		if (options && canvas) {//if selected object and canvas set default text
			console.log('set selected font-family ' +options.target.get('fontFamily'));
			$("#"+font_family_tool.picker.attr('id')+"-button span").text((options.target.get('fontFamily')));
			};
	};
	

    editorfn.destroyFontFamilyPicker = function(font_family_tool){
    	font_family_tool.picker.unbind();
    	font_family_tool.container.hide();    	
    };
	
	editorfn.addColorPicker = function(color_tool){
		color_tool.label = '<span class="label">Цвет</span>';
		color_tool.picker = '<div class="colorpicker-wrapper"><input id="colorpicker" name="#" type="hidden" /></div>';

		$(color_tool.container).
						append(color_tool.label).
						append(color_tool.picker);
		$('#colorpicker').minicolors({
		    textfield: false
		});	
		
	};
	
	editorfn.destroyColorPicker = function(color_tool){
    	$('#colorpicker').minicolors('destroy');
    	color_tool.container.html('');
    	color_tool.container.					
    					append(color_tool.label).
						append(color_tool.picker);
    	color_tool.container.hide();
	};
	
	
	editorfn.addFontStylePicker = function(options, canvas, font_style_tool){
				//console.log('set selected option ' +options.target.get('fontFamily'));
				var canvas_font_family = options.target.get('fontFamily'),
					pdf_bold, pdf_italic = false;
					
				if ($("option[id='"+canvas_font_family+"']").hasClass('pdf_bold')){
					pdf_bold = true;
				}
				if ($("option[id='"+canvas_font_family+"']").hasClass('pdf_italic')){
					pdf_italic = true;
				}
				if (pdf_bold || pdf_italic == true){//отключаем обе кнопки, даже если одна из них неактивна
					//console.log('активируем кнопки');
					editorfn.addEventHandlersToButtons(options, canvas);
					editorfn.updateFontButtonsByCanvas(options, font_style_tool);
					font_style_tool.container.show();	
				} else if (pdf_bold || pdf_italic == false) {
					editorfn.resetFontStyle(options);
					editorfn.destroyFontStylePicker(font_style_tool);
				}
	    	
		};
		
		editorfn.updateFontButtonsByCanvas = function(options, font_style_tool){
				if (options.target.get('fontWeight')=='bold'){
					font_style_tool.font_weight_button.addClass("pressed");
				} else {
					font_style_tool.font_weight_button.removeClass("pressed");
				};
				if (options.target.get('fontStyle')=='italic'){
					font_style_tool.font_style_button.addClass("pressed");
				} else {
					font_style_tool.font_style_button.removeClass("pressed");
				};
				
		};

		editorfn.resetFontStyle = function(options){
			options.target.set({
				fontWeight: 'normal',
				fontStyle: 'normal',
			});
		};

		editorfn.addEventHandlersToButtons = function(options, canvas){
			$(".font_style_button").click(function () {
				if ($(this).hasClass("pressed")){
					$(this).removeClass("pressed");
					if (options && canvas) {//if selected object and canvas
						if ($(this).attr('id') == 'font_weight'){
							options.target.set({fontWeight: 'normal'});
						}
						if ($(this).attr('id') == 'font_style'){
							options.target.set({fontStyle: 'normal'});
						};
		    			canvas.renderAll();
		    		}
				} else {
					$(this).addClass("pressed");
					if (options && canvas) {//if selected object and canvas
						if ($(this).attr('id') == 'font_weight'){
							options.target.set({fontWeight: 'bold'});
						};
						if ($(this).attr('id') == 'font_style'){
							options.target.set({fontStyle: 'italic'});
						};
		    			canvas.renderAll();
		    		}
				}
	    	});
		};
		
    	editorfn.destroyFontStylePicker = function(font_style_tool){
			font_style_tool.font_weight_button.unbind();
			font_style_tool.font_style_button.unbind();
    		font_style_tool.container.hide();	    		
    	};

		
		editorfn.initializeTextToolbar = function (){
			
		};
		
		
		editorfn.addTextInput = function(text_inputs_wrapper, field_count){
			sidebar_text_name = 'text_' +field_count;
			sidebar_text_id = sidebar_text_name;
			sidebar_text_value = 'Текст ' +field_count;
			$(text_inputs_wrapper).append('<tr id="'+field_count+'" class="embedded_text"><td class="text_container"><input type="text" name="'+sidebar_text_name+'" class="text_field" id="'+sidebar_text_id+'" value="'+sidebar_text_value+'"/></td><td><button class="remove_element" title="Удалить текст"><img src="/assets/icons/del-3.png" alt="Del-3"></button></td></tr>');	
		};
		
		editorfn.highlightElement = function(element_id, current_tab){
	    	$("#"+element_id+"").parent().parent().addClass('selected');
	    	$(current_tab).prop('checked', true);
		};
		
		editorfn.unHighlightAll = function(){
			$("div.tabs_cont").find(".selected").removeClass('selected');
		};
		
		
})();