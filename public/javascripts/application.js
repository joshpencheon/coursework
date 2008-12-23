// Attach the event onLoad. Using livequery,
// it will also get called whenever the dom changes.
$(document).ready(function($) {
	// Initialise Facebox links.
	$('a[rel*=facebox]').livequery(function() { $(this).facebox({
		loadingImage : '/images/facebox/loading.gif',
		closeImage   : '/images/facebox/closelabel.gif',
		opacity      : 0.1 })
	})
	
	// Initialise relative timestamps.
	$('abbr[class*=timeago]').livequery(function(){ 
		$(this).timeago();
	})
	
})

$.fn.updateThroughFade = function(time, text, callback) {
	$(this).fadeTo(time, 0.001, function(){
		if (callback) callback()
		$(this).text(text).fadeTo(time, 1)
	})
}

$.fn.replaceThroughFade = function(time, element, callback) {
	wrap = $(this).wrap(document.createElement('div')).parent()
	wrap.fadeTo(time, 0.001, function(){
		if (callback) callback()
		wrap.empty().html(element).fadeTo(time, 1, function() {
			wrap.replaceWith(element)
		})
	})
}

// Private method for jQuery to issue PUT and DELETE requests
function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data; data = {}
  }
  return jQuery.ajax({
    type: method, url: url, data: data,
    success: callback, dataType: type
  })
}


// Allows for jQuery to issue PUT and DELETE requests
// to interact with the RESTful routes of the application.
jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
	// delete is a reserved word in JavaScript.
  deleteRequest: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
})