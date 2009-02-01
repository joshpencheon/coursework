module CommentsHelper
  def time_later_for(comment)
    time = Time.now.ago((comment.created_at - comment.study.created_at).to_i)
    relative_time(time, :later => true)
  end
end
