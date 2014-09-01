$(document).ready(function(){
	if($("#slide_my_orders").exists()){
			$('#slide_my_orders').carouFredSel({
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
					                 container: '#slide_ord_pag',
					                 anchorBuilder: function(nr) { 
					                 	if (nr == '1'){
					                 		return '<a href="#" class="my_order"><span>печать фото</span></a>';
					                 	} else if (nr == '2'){
					                 		return '<a href="#" class="my_order"><span>печать документов</span></a>';	
					                 	}			                 	
					                 	}
					               }
					     });
			};
  });

