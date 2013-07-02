$(document).ready(function(){
    if($(".edit_order").exists()) {
        $(".edit_order").FormNavigate({
          message: "Все внесенные данные будут потеряны!\nВы действительно хотите прервать создание заказа?",
          aOutConfirm: "a.button_style"
        });
        
    }
  });

