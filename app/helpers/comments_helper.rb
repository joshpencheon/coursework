module CommentsHelper
  def time_later_for(comment)
    time_ago_in_words(Time.now.ago((comment.created_at - comment.study.created_at).to_i)) + ' later'
  end
end
