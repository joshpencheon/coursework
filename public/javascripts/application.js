// Attach the event onLoad.
jQuery(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
	  loadingImage : '/images/facebox/loading.gif',
	  closeImage   : '/images/facebox/closelabel.gif',
		opacity      : 0.1
	}) 
});

// The easiest way to stop this is to remove from the page.
// Or, call #stop() a few times.
jQuery.fn.pulsateLoop = function(){
	op1 = $.extend({times:3}, arguments[0])
	op2 = arguments[1] || 500
	$(this).effect('pulsate', op1, op2,
		function(){ $(this).pulsateLoop(op1, op2); });
};
