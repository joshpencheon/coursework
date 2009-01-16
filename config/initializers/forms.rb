# Replace <div> tags with <span> tags, as the form field will already be wrapped in a block element.
ActionView::Base.field_error_proc = 
  Proc.new{ |html_tag, instance| "<span class=\"field_with_errors\">#{html_tag}</span>" }
  
# A field now follows a corresponding label, and it is all wrapped in a paragraph tag.
# if the :no_label option evaluates to true, the field reverts to the default FormBuilder.
ActionView::Base.default_form_builder = ::ActionView::Helpers::LabellingFormBuilder