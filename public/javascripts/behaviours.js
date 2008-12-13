$(document).ready(function() {
	// Adds another file field to the study form
	$('#add_attachment').click(function(event){
		event.preventDefault()
		$('#attachments').after('<div class="file"><input id="study_new_attached_file_attributes__document" name="study[new_attached_file_attributes][][document]" size="30" type="file" /></div>');
		$('.file:last').hide().slideDown()
		$(this).text('Attach another file')
	})
	
	// Shows existing files attached to a study
	$('#manage_attachments').click(function(event) {
		event.preventDefault()
		$('#attachments').toggle('blind')
	})

	// Removes an existing file from a study
	$('.file_delete_link').click(function(event) {
		event.preventDefault()
		var parent = $(this).parent()
		if ($(this).hasClass('deleted')) {
			parent.fadeTo('slow', 1.0, function() { $(this).find('span').remove() })
		} else {
			parent.fadeTo('slow', 0.5).find('input').remove().end()
			.append('<span>will be deleted when you save this study. Click again to undelete.</span>')
		}
		$(this).toggleClass('deleted')
	})
	
	//******** USER ********//

	toggleAvatar = function() {
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
	}
	
	$('#user_destroy_avatar').attr("checked", null)
	
	$('#user_destroy_avatar').change(function() { toggleAvatar() })
	
	$('#hide_avatar').click(function() {
		toggleAvatar()
		return false
	})

	if ($('#user_email_hidden').attr("checked")) $('#privacy_help').show()
	
	$('#user_email_hidden').change(function() {
		var container = $('#privacy_help')
		if ($(this).attr("checked")) container.show('blind')
		else container.hide('blind')
	})
	
})