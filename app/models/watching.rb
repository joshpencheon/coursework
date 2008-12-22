class Watching < ActiveRecord::Base
  # This model wraps the join table between users and studies.
  belongs_to :user
  belongs_to :study
  
  def self.toggle(study, user)
    if study.watched_by? user
      delete_all([ "study_id = ? AND user_id = ?", study.id, user.id ])
    else
      create(:study_id => study.id, :user_id => user.id)
    end
  end
end
