$(document).ready(function() {
	
	//*********** NOTIFICATIONS ************
	
	$('.read_link').click(function(event) {
		event.preventDefault()		
		$.put($(this).attr("href"), {}, function(js) {
			$(event.target).text(eval(js))
		}, 'script')
	})

	$('.follow_link').click(function(event) {
		event.preventDefault()
		$.post($(this).attr("href"),{}, function(){}, 'script')
	})
	
	//*********** VIEW A STUDY *************
	
	$('.watch_study_link').click(function(event) {
		$(this).addClass('in_progress')
		$.post($(this).attr('href'), {}, function(js) {
			$(event.target).removeClass('in_progress')
				.updateThroughFade(150, eval(js))
		}, 'script')
		return false			
	})
	
	//********* EDITING A STUDY ************
	
	// Adds another file field to the study form
	$('#add_attachment').click(function(event){
		event.preventDefault()
		$('#attachments').after('\
			<div class="file"> \
				<input id="study_new_attached_file_attributes__document" name="study[new_attached_file_attributes][][document]" size="30" type="file" /> \
			</div>');
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
		if (parent.hasClass('deleted')) return false
		parent.fadeTo('slow', 0.5).addClass('deleted')
			.append('<span>will be deleted when you save this study.</span>')
		event.unbind()
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
		if ($(this).attr("checked")) container.fadeTo(1, 0.001).show('blind', {}, 200, function(){ 
			container.fadeTo(200, 1) })
		else container.fadeTo(200, 0.001, function(){container.hide('blind',{}, 200)})
	})
	
})