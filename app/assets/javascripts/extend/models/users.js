jQuery.validator.addMethod(
        "regex_name",
        function(value, element) {
  			return this.optional(element) || /^[#{АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщьъыэюя}A-Z\-}]*$/i.test(value);
		}, 
        "Можно только буквы и тире."
);

jQuery.validator.addMethod(
        "regex_phone",
        function(value, element) {
  			return this.optional(element) || /^(8|\+7)([\d]){10}$/.test(value);
		}, 
        "Телефон введен неверно."
);

jQuery.validator.addMethod(
        "regex_pass",
        function(value, element) {
  			return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
		}, 
        "Можно только цифры и латинские буквы."
);

$(document).ready(function(){

    //client validator for registration user
	if($("form#new_user").exists()){
   		$("form#new_user").validate({
    		rules: {
    			'user[first_name]': {
    				required: true,
    				minlength: 3,
    				regex_name: true	
    			},
    			'user[second_name]': {
    				required: true,
    				minlength: 3,
    				regex_name: true	
    			},
    		//	'user[email]': {
    		//		required: true,
    		//		email: true,
    		//		remote: {
    		//			url: "/users/check_email",
    		//			type: "get"
    		//		}
    		//	},
    			'user[phone]': {
    				required: true,
    				regex_phone: true,
    				remote: {
    					url: "/users/check_phone",
    					type: "get"
    				}
    			},
    			'user[password]': {
    				required: true,
    				regex_pass: true
    			},
    			'user[password_confirmation]': {
    				required: true,
    				equalTo: "#user_password"
    			},
    			'user[agreement]': {
    				required: true
    			}
    		},
    		messages: {
    			'user[first_name]': {
    				required: "Не должно быть пустым.",
    				minlength: "Слишком короткое имя."
    			},
    			'user[second_name]': {
    				required: "Не должно быть пустым.",
    				minlength: "Слишком короткая фамилия."	
    			},    			
    			'user[email]': {
    				required: "Не должно быть пустым.",
    				email: "Email введен неверно.",
    				remote: "Такой email уже есть."
    			},
    			'user[phone]': {
    				required: "Не должно быть пустым.",
    				remote: "Такой номер уже есть."
    			},
    			'user[password]': {
    				required: "Не должно быть пустым."
    			},
    			'user[password_confirmation]': {
    				required: "Не должно быть пустым.",
    				equalTo: "Пароли не совпадают."
    			},
    			'user[agreement]': {
    				required: "Нужно разрешить нам."
    			}
    		}
    		});
	};

	if($("form#edit_profile").exists()){
   		$("form#edit_profile").validate({
    		rules: {
    			'user[first_name]': {
    				required: true,
    				minlength: 3,
    				regex_name: true	
    			},
    			'user[second_name]': {
    				required: true,
    				minlength: 3,
    				regex_name: true	
    			},
    			'user[email]': {
    				required: true,
    				email: true,
    				remote: {
    					url: "/users/check_email",
    					type: "get"
    				}
    			},
    			'user[phone]': {
    				required: true,
    				regex_phone: true,
    				remote: {
    					url: "/users/check_phone",
    					type: "get"
    				}
    			}
    		},
    		messages: {
    			'user[first_name]': {
    				required: "Не должно быть пустым.",
    				minlength: "Слишком короткое имя."
    			},
    			'user[second_name]': {
    				required: "Не должно быть пустым.",
    				minlength: "Слишком короткая фамилия."	
    			},    			
    			'user[email]': {
    				required: "Не должно быть пустым.",
    				email: "Email введен неверно.",
    				remote: "Такой email уже есть."
    			},
    			'user[phone]': {
    				required: "Не должно быть пустым.",
    				remote: "Такой номер уже есть."
    			}
    		}
    		});
	};

	if($("form#edit_password").exists()){
   		$("form#edit_password").validate({
    		rules: {
    			'user[current_password]': {
    				required: true,
    				remote: {
    					url: "/users/check_pass",
    					type: "get"
    				}
    			},
    			'user[password]': {
    				required: true,
    				regex_pass: true
    			},
    			'user[password_confirmation]': {
    				required: true,
    				equalTo: "#user_password"
    			}
    		},
    		messages: {
    			'user[current_password]': {
    				required: "Нужен текущий пароль.",
    				remote: "Неверный пароль."
    			},
    			'user[password]': {
    				required: "Не должно быть пустым."
    			},
    			'user[password_confirmation]': {
    				required: "Не должно быть пустым.",
    				equalTo: "Пароли не совпадают."
    			}
    		}
    		});
	};

});
	  
