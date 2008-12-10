$(document).ready(function() {
	// Adds another file field to the study form
	$('#add_attachment').click(function(event){
		event.preventDefault()
		$('#attachments').after('<div class="file"><input id="study_new_attached_file_attributes__document" name="study[new_attached_file_attributes][][document]" size="30" type="file" /></div>');
		$('.file:last').hide().appearDown()
		$(this).text('Attach another file')
	})
	
	// Shows existing files attached to a study
	$('#manage_attachments').click(function(event) {
		event.preventDefault()
		$('#attachments').toggle('blind', {}, 'slow')
	})

	// Removes an existing file from a study
	$('.file_delete_link').click(function(event) {
		event.preventDefault()
		var parent = $(this).parent()
		if ($(this).hasClass('deleted')) {
			parent.fadeTo('slow', 1.0, function() {
				$(this).find('span').remove() }, 'jswing')
		} else {
			parent.fadeTo('slow', 0.5, 'jswing').find('input').remove().end()
			.append('<span>will be deleted when you save this study. Click again to undelete.</span>')
		}
		$(this).toggleClass('deleted')
	})
})