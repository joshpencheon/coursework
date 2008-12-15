class Watching < ActiveRecord::Base
  # This model wraps the join table between users and studies.
  belongs_to :user
  belongs_to :study
  
  def self.link(study, user)
    unless study.watched_by? user
      create(:study_id => study.id, :user_id => user.id)
    end
  end
  
  def self.unlink(study, user)
    delete_all([ "study_id = ? AND user_id = ?", study.id, user.id ])
  end
end
