$(document).ready(function(){

    //client validator
    if($("form#new_order_status").exists()){
    	var form = $("form#new_order_status");
    	validate_field(form);
    } else if ($("form#edit_order_status").exists()){
    	var form = $("form#edit_order_status");
    	validate_field(form);
    };
    
    
	function validate_field(form){
   		form.validate({
    		rules: {
    			'status[title]': {
    				required: true
    			},
    			'status[key]': {
    				required: true
   				}
    		},
    		messages: {
    			'status[title]': {
    				required: "Не должно быть пустым."
    			},
    			'status[key]': {
    				required: "Не должно быть пустым."
    			}
    		}
    		});
	};

});
	  
