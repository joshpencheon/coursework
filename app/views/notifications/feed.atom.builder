atom_feed do |feed|
  feed.title("NHS SDU - #{@tokened_user.name}'s notifications")
  
  @notifications.each do |notification|
    url = polymorphic_path(notification.event.news_item, :format => nil)
    feed.entry(notification, :url => url) do |entry|
      entry.title(event_title_for(notification.event))
      entry.content(event_items_for(notification.event), :type => 'html')
      entry.author do |author|
        author.name(notification.event.user.name)
      end
    end
  end
end