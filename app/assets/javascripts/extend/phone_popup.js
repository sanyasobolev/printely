$(document).ready(function(){
	
	$("div#call").click(function() {
		$("div.phone_popup").css("display", "block");
	});
	
	$("div.phone_popup .exit").click(function() {
		$("div.phone_popup").css("display", "none");
	});

});
	  
