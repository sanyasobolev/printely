$(document).ready(function() {
	
	var  form = $("form");
	
	//определяем объекты
	var order = {
		order_id: form.attr("id"),
		url_for_update_delivery_price: "/order/set_delivery_price",
	};
		
    //контроль ухода пользователя со страницы
    form.FormNavigate({
       message: "Вся несохраненная информация по доставке будет потеряна!\nУходим отсюда?",
       aOutConfirm: "input.button_style, a.no_confirm"
    });

	//clear value 'выберите' in select
	deliveryfn.clear_select();
	
	//delivery datepicker
	calendarfn.set_datepicker('#datepicker', 0, false);
	
	//delivery timepicker
	calendarfn.set_timepicker('#timepicker_start', '07:00', '21:00');
	calendarfn.set_timepicker('#timepicker_end', '09:00', '23:00');
	
	$("#timepair").datepair({
		defaultTimeDelta: 7200000,
		anchor: 'start',
		endClass: 'end',
	});
	
	//update order when update delivery	
	deliveryfn.update_order(order);

   //client validator
    form.validate({
      	ignore: "",
    	rules: {
    		'order[delivery_address]': "required",
    		'order[delivery_town_id]':"required",
    		'order[delivery_date]':{
    			required: true,
    			dateRU: true,
    		}
    	},
    	messages: {
    		'order[delivery_address]': "?",
    		'order[delivery_town_id]':"?",
    		'order[delivery_date]':"?",
    	},
    	submitHandler: function(form){
    		$("input.submit").disableButton("Переходим...");
    		form.submit();
    	}
    });

});

