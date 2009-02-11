$(document).ready(function() {
	
	//*************** SIDEBAR **************
	
	// Hide an empty sidebar
	$('#sidebar').livequery(function(){
		if ($(this).find('noscript').siblings().length == 0) $(this).hide()
	})
	
	//**************** FLASH ***************
	
	setTimeout("Flash.hide()", 5000)
	
	//*********** CUSTOM FACEBOX ***********
	
	// Adds line-breaks to text documents
	$(document).bind('reveal.facebox', function() { 
		var box = $('#facebox .content')	
		if (box.hasClass('formatted')) {
			box.html( box.html().replace(/\n/g, '<br/>') )
		}
	})
	
	//*********** TIMESTAMPS ***************
	
	$('.relative_time').livequery(function() { $(this).timeago().show() });

	$('.relative_time_later').livequery(function() {
		oldSuffix = jQuery.timeago.settings.strings.suffixAgo
		$.extend(jQuery.timeago.settings.strings, {suffixAgo: 'later'})
		$(this).timeago().show()
		$.extend(jQuery.timeago.settings.strings, {suffixAgo: oldSuffix})
	});
	
	//*********** PERMISSIONS **************
	
	$('#permission_message').focus(function(event) {
		counter = $('#permission_message_length')
		var permissionMessageCounter = setInterval(function() {
			length = 255 - $(event.target).attr('value').length
			if (length < 0) { clr = 'red' } else { clr = '#444' }
			counter.text(length).css({color: clr})
		}, 200)
	})
	
	$('#permission_message').blur(function() {
		clearInterval(permissionMessageCount)
	})
	
	//*********** NOTIFICATIONS ************

	Notification.capsule.init()

	$('a.read_link').livequery(function() {
		$(this).click(function(event) {
			event.preventDefault()
			$(this).addClass('in_progress')
			Notification.capsule.set(null);
			$.put($(this).attr("href"), {}, function() {			
				$(event.target).removeClass('in_progress').toggleClass('read')
			}, 'script')
		})
	})
	
	$('a.load_notification_link').livequery(function() {
		$(this).click(function(event) {
			event.preventDefault()
			$(this).text('Loading details...')
			$.get($(this).attr('href'), {}, function(data){
				$(event.target).remove()
			}, 'script')
		})
	})
	
	$('a.follow_link').livequery(function() {
		$(this).click(function(event) {
			event.preventDefault()
      $.post($(this).attr("href"),{}, function(){}, 'script')
    })
	})
	
	
	//*********** SEARCH FORM **************
	
	if (!SHOW_SEARCH_BOX) {
		$('#search_wrapper').hide()
		$('#search_filters').hide()
		$('#search_filters_link').show().click(function() {
			$(this).fadeOut('fast', function(){
				$('#search_filters').fadeIn('fast') })
			return false
		})	
	}
	
	$('#search_form').submit(function() {
		input = $('#search')
		if (input.val() == 'Search...') input.val('')
		return true
	})
	
	$('#search').focus(function() {
		$(this).select()
	}).blur(function() {
		if ($(this).val() == '') $(this).val('Search...')
	})
	
	$('#search_link a, #cancel_search').click(function() {
		$('#search_wrapper').slideToggle('fast')
		
		return false
	})
	
	//*********** VIEW A STUDY *************
	
	$('.watch_study_link').click(function(event) {
		anchor = $(this) // Prevent just image being clicked.
		event.preventDefault()
		if (!anchor.hasClass('in_progress')) {
			anchor.addClass('in_progress')
			$.post(anchor.attr('href'), {}, function(js) {
				anchor.removeClass('in_progress')
					.updateThroughFade(150, eval(js))
			}, 'script')		
		}
	})
	
	$('#download_link').click(function() {
		$.facebox($('#download_options').html())
		return false
	});
	
	$('.attached_file').hover(function() {
		$(this).find('.file_info').animate({marginTop: '1.1em'}, 100)
		$(this).find('.file_size').fadeIn('fast')
	}, function() {
		$(this).find('.file_info').animate({marginTop: '1.5em'}, 100)
		$(this).find('.file_size').fadeOut('fast')
	})
	
	$('.preview_attachment').click(function() {
		$.facebox($(this).parents('.attached_file').find('.notes').html())
		return false
	})
	
	//********* EDITING A STUDY ************
	
	TagList.initialize('#study_tag_list', '.tag')
	
	$('#hide_tags_link').click(function() {
		cloud = $('#tag_cloud')
		
		if (cloud.is(':visible'))
			cloud.fadeTo(200, 0.001, function() { 
				cloud.hide('blind',{}, 200) 
			})
		
		return false
	})
	
	$('#study_tag_list').focus(function() {
		cloud = $('#tag_cloud')
		
		if (cloud.is(':hidden'))
			cloud.fadeTo(1, 0.001).show('blind', {}, 200, function(){ 
				cloud.fadeTo(200, 1) 
			}) 
	})
	
	$('#add_attachment').show()
	// Adds another file field to the study form
	$('#add_attachment').click(function(event){
		$(this).text('Fetching...')
		$.get($(this).attr('href'), function(html) {
			input = $(html).hide()
			$('#new_attachments').append(input)
			input.slideDown()

			$('div.new_attachment').removeClass('odd')			
			$('div.new_attachment:odd').addClass('odd')

			$(event.target).text('Add another attachment')
		}, 'text')
		
		return false
	})
	
	ThumbnailSelect.init()
	
	$('.attached_file_notes').hide()
	$('.show_attached_file_notes').show()
	
	$('.show_attached_file_notes').livequery(function() {
		$(this).click(function() {
			$(this).toggleClass('highlight')
			$(this).parents('.fields').find('.attached_file_notes').toggle('fast')
			return false
		})
	})
	
	$('.delete_attachment_link').click(function() {
		if (confirm('Are you sure you want to delete this attachment?')) {
			if ($('.existing_attachment').length == 1)
				{ target = $('#existing_attachments').parent() }
			else 
			  { target = $(this).parents('.existing_attachment') }
			
			target.slideUp(function() {
				$(this).remove()
				
				message = $('#delete_message')
				if (message.is(':hidden')) message.fadeIn('slow')
				else message.effect('highlight', {}, 3000)
			})
		}
		return false
	})
	
	$('.delete_new_attachment_link').livequery(function() {
		$(this).click(function() {
			$(this).parents('.new_attachment').slideUp(function() {
				$(this).remove()
			})
			return false
		})
	})
	
	//******** COMMENTS ********//
		
	$('#new_comment').submit(function() {
		button = $(this).find('input[type=submit]')
		fields = $(this).find('input, textarea')
		
		$(this).ajaxSubmit({
			dataType: 'script',
			clearForm: true,
			beforeSubmit: function() {
				button.attr('value', 'Posting...')
			},
			success: function() {
				$('#comments .empty_message').hide()
				button.attr('value', 'Post another comment')
				fields.removeAttr('disabled')
			}
		})
		
		fields.attr('disabled', 'disabled')
		return false
	})
	
	$('#show_formatting_help').click(function() {
		box = $('#formatting_help')
		if (box.is(':hidden')) {
			$(this).text($(this).text().replace(/show/, 'hide'))
			box.fadeTo(0.001, 0.001).slideDown('fast', function() {
				box.fadeTo('fast', 1)
			})
		} else {
			$(this).text($(this).text().replace(/hide/, 'show'))
			box.fadeTo('fast', 0.001, function() {
				box.slideUp('fast')
			})
		}
		
		return false
	})
	
	//******** USER ********//
	
	$('#user_destroy_avatar').attr("checked", null)
	
	$('#user_destroy_avatar').change(function() { 
		var fields = $('#user_fields')
		var box = $('#avatar_upload_container')
		var avatar = $('#avatar')
		var leftSide = $('#avatar_display')		
		var rightSide = $('#avatar_fields')
		
		if (!rightSide.is(':hidden')) {
			avatar.fadeTo('slow', 0.5)
			rightSide.fadeOut('fast', function() {
				box.animate({ width: leftSide.outerWidth() + 5 + 'px' })
				fields.animate({ marginRight: leftSide.outerWidth() + 70 + 'px' })
			})
		} else {
			avatar.fadeTo('fast', 1)
			box.css({width: box.width() + 'px'})
			box.animate({ width:'47%' }, function() { rightSide.fadeIn() })
			fields.animate({ marginRight:'55%' })
		}	
	})

	if ($('#user_email_hidden').attr("checked")) $('#privacy_help').show()
	
	$('#user_email_hidden').change(function() {
		var container = $('#privacy_help')
		if ($(this).attr("checked")) container.fadeTo(1, 0.001).show('blind', {}, 200, function(){ 
			container.fadeTo(200, 1) })
		else container.fadeTo(200, 0.001, function(){container.hide('blind',{}, 200)})
	})
	
})