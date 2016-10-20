$(document).ready(function(){

    //client validator
    if($("form#new_paper_specification").exists()){
    	var form = $("form#new_paper_specification");
    	validate_field(form);
    } else if ($("form#edit_paper_specification").exists()){
    	var form = $("form#edit_paper_specification");
    	validate_field(form);
    };
    
    
	function validate_field(form){
   		form.validate({
    		rules: {
    			'pspec[price]': {
    				required: true
    			}
    		},
    		messages: {
    			'pspec[price]': {
    				required: "Не должно быть пустым."
    			}
    		}
    		});
	};

});
	  
