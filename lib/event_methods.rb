module EventMethods
  private
  
  def helpers
    ActionController::Base.helpers
  end
  
  def logger_for(instance)
    instance.class.logger
  end
  
  def was_or_were(array)
    if array.length == 1 && array.first != array.first.pluralize
      'was'
    else
      'were'
    end
  end
  
end