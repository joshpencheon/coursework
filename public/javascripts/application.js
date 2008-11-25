// Attach the event onLoad.
jQuery(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
	  loadingImage : '/images/facebox/loading.gif',
	  closeImage   : '/images/facebox/closelabel.gif',
		opacity      : 0.3
	}) 
})
