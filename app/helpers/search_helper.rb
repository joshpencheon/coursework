module SearchHelper
  def options_for_lookup(model, value_method, text_method, prompt)
    "<option value=''>#{prompt}</option>" + 
      options_from_collection_for_select(model.all, value_method, text_method)
  end
  
  def options_for_select_with_prompt(options, prompt, selected = nil)
    "<option value=''>#{prompt}</option>" + options_for_select(options, selected)
  end
end