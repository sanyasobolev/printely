$(document).ready(function() {
	
	var  form = $("form");
	
    form.submit(function(event)
		{ 
			$("input.submit").disableButton("Оформляем...");
		});
  
});

