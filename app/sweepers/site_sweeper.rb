class SiteSweeper < ActionController::Caching::Sweeper
  observe Study, Comment

  def after_save(record)
    expire_cache_for(record)
  end
  

  def after_destroy(record)
    expire_cache_for(record)
  end
  
  private
  
  def expire_cache_for(record)
    if record.is_a?(Study)
      study = record
      call_rake('ts:in:delta')
    else
      study = record.study
    end
    
    # Expire the study
    with_options :controller => 'studies' do |studies|
      studies.expire_fragment(:action_suffix => "#{study.id}_small") 
      studies.expire_fragment(:action_suffix => "tags")
      studies.expire_fragment(:action => 'show',  :id => study.to_param, :action_suffix => "study_#{study.id}" )
    end
    
    # Expire the principle user's page
    expire_fragment(:controller => 'users', :action => 'show', :id => study.user.to_param, :action_suffix => 'events')
  end

end