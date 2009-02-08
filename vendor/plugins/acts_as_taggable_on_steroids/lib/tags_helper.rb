module TagsHelper
  # See the README for an example using tag_cloud.
  def tag_cloud(tags, classes)
    return if tags.empty?
    
    max_count = tags.sort_by(&:count).last.count
    
    tags.each do |tag|
      begin
        index = ((tag.count / max_count) * (classes.size - 1)).round
      rescue 
        index = 0
      end
      
      yield tag, classes[index]
    end
  end
end
