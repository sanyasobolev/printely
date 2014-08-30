$(document).ready(function(){

    //client validator
    if($("form#new_subservice").exists()){
    	var form = $("form#new_subservice");
    	validate_field(form);
    } else if ($("form#edit_subservice").exists()){
    	var form = $("form#edit_subservice");
    	validate_field(form);
    };
    
    
	function validate_field(form){
   		form.validate({
    		rules: {
    			'subservice[title]': {
    				required: true
    			},
    			'subservice[synopsis]': {
    				required: true
   				},
   				'subservice[subservice_header_icon]': {
   					required: true
   				}
    		},
    		messages: {
    			'subservice[title]': {
    				required: "Не должно быть пустым."
    			},
    			'subservice[synopsis]': {
    				required: "Не должно быть пустым."
    			},
    			'subservice[subservice_header_icon]': {
    				required: "Не должно быть пустым."
    			}
    		}
    		});
	};

});
	  
