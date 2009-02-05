class CommentEvent
  include EventMethods
  
  def after_save(comment)
    comment.study.events.create(
      :user_id => comment.user_id,
      :data   => comment.id,
      :title   => ['commented on the', 'study', comment.study.title] )
  end
end