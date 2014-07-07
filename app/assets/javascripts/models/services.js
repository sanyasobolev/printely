$(document).ready(function(){

    //client validator
    if($("form#new_service").exists()){
    	var form = $("form#new_service");
    	validate_field(form);
    } else if ($("form#edit_service").exists()){
    	var form = $("form#edit_service");
    	validate_field(form);
    };
    
    
	function validate_field(form){
   		form.validate({
    		rules: {
    			'service[title]': {
    				required: true
    			},
    			'service[synopsis]': {
    				required: true
   				}
    		},
    		messages: {
    			'service[title]': {
    				required: "Не должно быть пустым."
    			},
    			'service[synopsis]': {
    				required: "Не должно быть пустым."
    			}
    		}
    		});
	};

});
	  
