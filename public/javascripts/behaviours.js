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
		$('#attachments').toggle('blind', {}, 'slow', null, 'EaseOutBounce')
	})

	// Removes an existing file from a study
	$('.file_delete_link').click(function(event) {
		event.preventDefault()
		var parent = $(this).parent()
		if ($(this).hasClass('deleted')) {
			parent.fadeTo('slow', 1.0, function() {
				$(this).find('span').remove() })
		} else {
			parent.fadeTo('slow', 0.5).find('input').remove().end()
			.append('<span>will be deleted when you save this study. Click again to undelete.</span>')
		}
		$(this).toggleClass('deleted')
	})
	
	//******** USER ********//
	
	$('#user_destroy_avatar').change(function() {
		
		if ($(this).attr("checked")) {
			$('#avatar_fields').fadeOut('fast')
			$('#avatar').fadeTo('fast', 0.5, function(){
				$('#avatar_upload_container').animate({width:'20%'}, 'fast')
			})
		} else {
			$('#avatar_upload_container').animate({width:'50%'}, 'fast', function(){
				$('#avatar_fields').fadeIn('fast')				
			})
			$('#avatar').fadeTo('fast', 1)
		}
	})
	
	$('#replace_avatar').click(function() {
		$('#user_avatar').toggle('fast')
		if ($(this).text().match(/change/i))
			$(this).text('Cancel')
		else 
			$(this).text('Change my avatar') 
	})
	
})