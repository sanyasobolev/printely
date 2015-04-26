(function( $ ){
   $.fn.disableButton = function(text) {
		current_width = this.width();
		this.val(text).prop('disabled', true);
		this.width(current_width);
        return this;
   }; 
})( jQuery );