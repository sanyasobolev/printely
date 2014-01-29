// обработчик slide-панели
$(function() {
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
});

$(document).ready(function(){
			$('#slide_orders').carouFredSel({
					       prev : "left",
					       next : "right",
					       height: "variable",
					       auto : false,
					       swipe: {
					              onTouch	: true,
					              onMouse	: true
					             },
					       circular: false,
					       items: 1,
					       align: "center",
					       cookie: true,
					       pagination: {
					                 container: '#slide_img_pag',
					                 anchorBuilder: function(nr) { 
					                 	if (nr == '1'){
					                 		return '<a href="#"><span>На печать фото</span></a>';
					                 	} else if (nr == '2'){
					                 		return '<a href="#"><span>На печать документов</span></a>';	
					                 	} else if (nr == '3'){
					                 		return '<a href="#"><span>На сканирование</span></a>';
					                 	}					                 	
					                 	}
					               }
					     });
});

