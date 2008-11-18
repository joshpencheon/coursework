require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  def test_valid_study_is_valid
    assert_valid(valid_study)
  end
  
  private 
  
  def valid_study
    Study.new(:title => 'a valid title', :description => 'some valid content, pretty boring')
  end
end
