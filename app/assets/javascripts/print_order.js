$(document).ready(function(){
    if($(".edit_print_order").exists()) {
        //контроль ухода пользователя со страницы
        $(".edit_print_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style, a.link_delete_docfile"
        });

        //clear value 'выберите' in select
        $("select#order_delivery_street").change(function(event){
            $('[value=""]',event.target).remove();
        });

		
        var order_id = $("form.edit_print_order").attr("id"),
            url_for_update_order = "/order/ajaxupdate";

        //при любом изменении в таблице, устанавливаем тип доставки "курьер"
        $("table.order_delivery").change(function(event){
            var selected_delivery = 'Курьер'
            $.post( url_for_update_order, {id: order_id, delivery_type: selected_delivery} )
        });
            
        //подключение хендлеров по управлению ценой (при уже загруженных документах - в случае рефреша страницы)
        $("select[name*='print_format']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var selected_print_format = $(this).val(),
              document_id = this.parentNode.parentNode.id;
              url = "/document/ajaxupdate";
          $.post( url, 
          	{id: document_id, print_format: selected_print_format},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	);
        });

        $("select[name*='paper_type']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var selected_paper_type = $(this).val(),
              document_id = this.parentNode.parentNode.id;
              url = "/document/ajaxupdate";
          $.post( url, 
          	{id: document_id, paper_type: selected_paper_type},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	);

        });

        $("input[name*='quantity']:not([class='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('change', function(event){
          var selected_quantity = $(this).val(),
              document_id = this.parentNode.parentNode.id;
              url = "/document/ajaxupdate";
          selected_quantity = validate(parseInt(selected_quantity));
          $(this).val(selected_quantity);
          $.post( url, 
          	{id: document_id, quantity: selected_quantity},
          	function() {
               $.post( url_for_update_order, {id: order_id} );
  				}
          	 );
        });

        //обновление цены после удаления одного документа
        $("a.link_delete_docfile:not([handler-status='with_priceEventHandler'])").attr('handler-status', 'with_priceEventHandler').bind('click', function(event){
          setTimeout(function(){$.post( url_for_update_order, {id: order_id} )}, 1000);
        });

        //работа переключателя количества файлов
        $("button.increase:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) + 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });
        $("button.decrease:not([class*='with_priceEventHandler'])").addClass("with_priceEventHandler").bind('click', function(event){
          var selected_input_quantity = $(this).siblings("input[id*='quantity']");
          new_value = parseInt(selected_input_quantity.val()) - 1 ;
          new_value = validate(new_value);
          selected_input_quantity.val(new_value);
          selected_input_quantity.change();
        });

        //проверка значения количества файлов для печати
        function validate(value){
          if (value < 1 || isNaN(value) == true) {
            value = 1;
          } else if (value > 100) {
            value = 100;
          }
          return value
        };
		//time
        $('#timepicker_start').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:00', 'maxTime': '23:30' });
        $('#timepicker_end').timepicker({ 'timeFormat': 'H:i', 'scrollDefaultNow': true , 'minTime': '07:30', 'maxTime': '00:00' });
    }
  });

