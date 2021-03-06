$(document).ready(function(){
	
    	//float header for show order view
		if ($("table#fileList tr.document").length > 1) {
		$('table#fileList').floatThead({
			floatTableClass: 'floatTheadfileListOrder',
			debounceResizeMs: 100
			});
		}
		
		//custom search
	    $('form').on('click', '.remove_fields', function(event) {
	      $(this).closest('.field').remove();
	      return event.preventDefault();
	    });
	    return $('form').on('click', '.add_fields', function(event) {
	      var regexp, time;
	      time = new Date().getTime();
	      regexp = new RegExp($(this).data('id'), 'g');
	      $(this).before($(this).data('fields').replace(regexp, time));
	      return event.preventDefault();
	    });
		
});
	  
