$(document).ready(function(){
    if($("#form_edit_order").exists()) {
        $("#form_edit_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: 'a.button_style'
        });
    }
  });

