jQuery.fn.extend({
  FormNavigate: function(o){
    var formdata_original = false;
    jQuery(window).bind('beforeunload', function (){
      if (!formdata_original) return settings.message;
    });

    var def = {
      message: '',
      aOutConfirm: 'a:not([target!=_blank])'
    };
    var settings = jQuery.extend(false, def, o);

//    jQuery(this).find("input[type=text], textarea, select, input[type='password'], input[type='radio'], input[type='checkbox'], input[type='file']").live('change keypress', function(event){
//      formdata_original = false;
//    });


  //фильтрация ссылок на странице по входному параметру--------------------------------------
    if (o.aOutConfirm && o.aOutConfirm != def.aOutConfirm){
      jQuery('a').addClass('aOutConfirmPlugin');
      jQuery(settings.aOutConfirm).removeClass("aOutConfirmPlugin");
      jQuery(settings.aOutConfirm).click(function(){
        formdata_original = true;
        return true;
      });
    }

    jQuery("a.aOutConfirmPlugin").click(function(){
      if (formdata_original == false)
        if(confirm(settings.message)) //если нажали ок в окне, то
          formdata_original = true;
      return formdata_original;
    });

    jQuery(this).find(":submit, input[type='submit']").click(function(){
      formdata_original = true;
    });
    
  }
});