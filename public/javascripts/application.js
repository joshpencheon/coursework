// Attach the event onLoad. Using livequery,
// it will also get called whenever the dom changes.
jQuery(document).ready(function($) {
	$('a[rel*=facebox]').livequery(function() { $(this).facebox({
		  loadingImage : '/images/facebox/loading.gif',
		  closeImage   : '/images/facebox/closelabel.gif',
			opacity      : 0.1 })
	})
})

$.fn.spin = function() {
	$(this).after('<img src="/images/spinner.gif"/>')
}
