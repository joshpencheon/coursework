// Attach the event onLoad. Using livequery,
// it will also get called whenever the dom changes.
jQuery(document).ready(function($) {
	$('a[rel*=facebox]').livequery(function() { $(this).facebox({
		  loadingImage : '/images/facebox/loading.gif',
		  closeImage   : '/images/facebox/closelabel.gif',
			opacity      : 0.1 })
	})
})

$.fn.appearDown = function(customOptions) {
	options = { duration:750 }
	$.extend(options, customOptions || {})
	element = $(this)
	var elementHeight = element.height()
	element.height(0).css({opacity:0})
	element.animate({height: elementHeight, opacity: 1}, options)
}

$.fn.fadeUp = function(customOptions) {
	options = { duration:750 }
	$.extend(options, customOptions || {})
	element = $(this)
	element.animate({height: 0, opacity: 0}, options)
}

jQuery.easing.def = "easeOutBounce";
