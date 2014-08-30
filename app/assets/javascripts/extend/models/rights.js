$(document).ready(function(){

    //client validator
    if($("form#new_right").exists()){
    	var form = $("form#new_right");
    	validate_field(form);
    } else if ($("form#edit_right").exists()){
    	var form = $("form#edit_right");
    	validate_field(form);
    };
    
    
	function validate_field(form){
   		form.validate({
    		rules: {
    			'right[name]': {
    				required: true
    			},
    			'right[controller]': {
    				required: true
   				},
   				'right[action]': {
   					required: true
   				},
   				'right[description]': {
   					required: true
   				}
    		},
    		messages: {
    			'right[name]': {
    				required: "Не должно быть пустым."
    			},
    			'right[controller]': {
    				required: "Не должно быть пустым."
    			},
    			'right[action]': {
    				required: "Не должно быть пустым."
    			},
    			'right[description]': {
    				required: "Не должно быть пустым."
    			}
    		}
    		});
	};

});
	  
