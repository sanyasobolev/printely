$(document).ready(function(){

    //client validator
	if($("form#new_letter").exists()){
   		$("form#new_letter").validate({
    		rules: {
    			'letter[name]': {
    				required: true,
    				minlength: 3
    			},
    			'letter[email]': {
    				required: true,
    				email: true
   				},
    			'letter[question]': {
    				required: true,
      				rangelength: [3, 1000]
    			}
    		},
    		messages: {
    			'letter[name]': {
    				required: "Не должно быть пустым.",
    				minlength: "Слишком короткое ФИО."
    			},
    			'letter[email]': {
    				required: "Не должно быть пустым.",
    				email: "Email введен неверно.",
    			},
    			'letter[question]': {
    				required: "Не должно быть пустым.",
    				rangelength: "Длина письма от 3 до 1000 знаков."
    			}
    		}
    		});
	};


});
	  
