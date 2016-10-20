jQuery( document ).ready( 

 function( $ ) {

	if($("#slide_image").exists()){
	 	$(window).bind('resize.x', function() {
	                    $('#slide_image').carouFredSel({
	                            prev : "left",
	                            next : "right",
	                            swipe: {
	                                onTouch	: true,
	                                onMouse	: true
	                            },
	                            circular: true,
	                            items: 1,
	                            width: $(window).width(),
	                            cookie: true,
	                            auto : {
	                                pauseDuration: 7000
	                            },
	                            pagination: {
	                                    container: '#slide_img_pag'
	                            }
	                    });
	                    
	              }).trigger('resize.x');
      };
	
	//проверка раскладки
	$(function(){
		$(':password').keyboardLayout();
	});
	
		
});
	  
