// Attach the event onLoad. Using livequery,
// it will also get called whenever the dom changes.
$(document).ready(function($) {
	
	// Initialise Facebox links.
	$('a[rel*=facebox]').livequery(function() { $(this).facebox({
		loadingImage : '/images/facebox/loading.gif',
		closeImage   : '/images/facebox/closelabel.gif',
		opacity      : 0.3 })
	})	
})

$.fn.updateThroughFade = function(time, text, callback) {
	if ($(this).is(':hidden')) {
		if (callback) callback()
		$(this).html(text).fadeIn(time*2)
	}
	else {
		$(this).fadeTo(time, 0.001, function(){
			if (callback) callback()
			$(this).html(text).fadeTo(time, 1)
		})		
	}
}

// Wraps the target, fades the wrapper, and replaces it's contents.
$.fn.replaceThroughFade = function(time, element, callback) {
	wrap = $(this).wrap(document.createElement('div')).parent()
	
	if ($(this).is(':hidden')) {
		if (callback) callback()
		wrap.empty().html(element).fadeIn(time*2, function() { wrap.replaceWith(element) })
	} else {
		wrap.fadeTo(time, 0.001, function(){
			if (callback) callback()
			wrap.empty().html(element).fadeTo(time, 1, function() { wrap.replaceWith(element) })
		})
	}
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

var TagList = {
	
	initialize: function(field, tagSelector) {
		this.field = $(field)
		this.tagLinks = $(tagSelector)
		
		this.tagLinks.click(function(event) {
			TagList.toggle($(this).text().toLowerCase(), $(this))
			
			return false
		})
		
		TagList.manageLinks()
	},
	
	toggle: function(tag, link) {
		if (TagList.active(tag)) TagList.remove(tag)
		else TagList.add(tag)
	},
	
	manageLinks: function() {
		this.tagLinks.each(function(index) {
			if (TagList.active($(this).text().toLowerCase())) $(this).addClass('active')
			else $(this).removeClass('active')
		})
	},
	
	add: function(tag) {
		newTags = TagList.list().concat(tag).join(', ')
		TagList.set(newTags)
	},
	
	remove: function(tagToRemove) {
		newTags = TagList.list().filter(function(tag) {
			return tag != tagToRemove
		}).join(', ')
		TagList.set(newTags)		
	},
	
	set: function(newTags) {
		TagList.field.val(newTags)
		TagList.manageLinks()
	},
	
	list: function() {
		return TagList.field.val().split(/\s*,\s*/).map(function(tag){
			return tag.toLowerCase()
		}).filter(function(tag){ return tag != '' })
	},
	
	active: function(tag) {
		return !!(TagList.list().indexOf(tag.toLowerCase()) >= 0)
	}
}

var Flash = {
	hide: function() {
		$('.flash').fadeTo('fast', 0.1, function() { 
			$(this).slideUp('fast')
		})
	}
}

var Notification = {
	counts: {
		setEvents: function(value) {
			this._set('.event_count', value)
		},
		
		setRequests: function(value) {
			this._set('.request_count', value)
		},
		
		_set: function(elements, value) {
			if (parseInt(value) == 0) $(elements).fadeOut('slow')
			else {
				$(elements).updateThroughFade('fast', value)
			}
		}
	},
		
	capsule: {
		init: function() {
			if (!this.element) 
				this.element = $('#notification_count').click(function() { 
					Notification.capsule.updateRemotely() 
				})
		},
		
		set: function(value) {
			this.value = value
			if (value == null) value = $('<img src="/images/spinner_white_red.gif"/>')
			if (this.element) {
				if (parseInt(value) == 0) this.element.fadeOut('slow') 
			  else this.element.html(value).fadeIn('slow')
			}
			else this.create(value)
		},
		
		updateRemotely: function() {
			this.spin()
			$.ajax({ url: "/notifications/count", type: "GET", dataType: "text",			
			  success: function(count) { Notification.capsule.set(count) }
			});
		}, 
		
		spin: function() {
			this.set(null)
		}
	}
}