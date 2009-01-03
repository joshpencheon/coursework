$(document).ready(function() {
	
	//*********** CUSTOM FACEBOX ***********
	
	$(document).bind('reveal.facebox', function() { 
		var box = $('#facebox .content')	
		// Add linebreaks 
		if (box.hasClass('formatted')) {
			box.html( box.text().replace(/\n/g, '<br/>') )
		}
	})
	
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

	$('form.button-to input[type=submit]').button_to_link()

	$('a.read_link').livequery(function() {
		$(this).click(function(event) {
			event.preventDefault()		
			$(this).addClass('in_progress')
			Notification.capsule.set(null);
			$.put($(this).attr("href"), {}, function() {
				$(event.target).removeClass('in_progress')
			}, 'script')
		})
	})
	
	$('a.follow_link').livequery(function() {
		$(this).click(function(event) {
      event.preventDefault()
      $.post($(this).attr("href"),{}, function(){}, 'script')
    })
	})
	
	//*********** VIEW A STUDY *************
	
	$('.watch_study_link').click(function(event) {
		event.preventDefault()
		$(this).addClass('in_progress')
		$.post($(this).attr('href'), {}, function(js) {
			$(event.target).removeClass('in_progress')
				.updateThroughFade(150, eval(js))
		}, 'script')		
	})
	
	$('.attached_file').hover(function() {
		$(this).find('.info').show(100)
	}, function() {
		$(this).find('.info').hide(100)
	});
	
	//********* EDITING A STUDY ************
	
	$('#add_attachment').show()
	// Adds another file field to the study form
	$('#add_attachment').click(function(event){
		var parent = $(this).parent()
		input = $('\
			<p class="new_attachment">\
				<input id="study_new_attached_file_attributes__document" name="study[new_attached_file_attributes][][document]" size="30" type="file" />\
			</p>')
		input.insertBefore(parent)
		input.hide().slideDown()
		
		$('p.new_attachment:even').addClass('odd')
		
		var button = parent.parent().find('input[type=submit]')
		if (!button.attr('value').match(/attachments/)) 
			button.attr('value', 'Save attachments')
		return false
	})
	
	$('#add_attachment_submit').click(function() {
		if ($(this).attr(value).match(/ing/)) return false
		value = $(this).attr('value').replace(/Save/, 'Saving') + '...'
		$(this).attr('value', value)
		return true
	})
	
	$('.delete_attachment_link').hover(function() {
		$(this).parents('.existing_attachment').addClass('over')
	}, function() {
		$(this).parents('.existing_attachment').removeClass('over')
	});
	
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