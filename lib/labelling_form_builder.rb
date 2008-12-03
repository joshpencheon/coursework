class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      if !options.delete(:no_label)
        label = label_with_errors(field, options.delete(:label))
        @template.content_tag(:p, label + super)
      else
        super
      end
    end
  end
  
  def label_with_errors(field, text = nil)
    label_contents = text || field.to_s.humanize.capitalize
        if errors = object.errors[field]
          label_contents << ' ' << @template.content_tag(:span, [errors].flatten.first, :class => 'error_description')
        end
    @template.label_tag(field, label_contents)
  end
  
  private
  
  def label_tag(field, text)
    content_tag :label, label_contents, :for => field
  end
    
end



