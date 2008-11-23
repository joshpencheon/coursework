require 'test_helper'

class ClassExtensionTest < Test::Unit::TestCase
end

class StringExtensionTest < ClassExtensionTest
  def test_capitalize_name
    assert_capitalized 'john mcdonald', 'John McDonald'
    assert_capitalized "billy o'reilly", "Billy O'Reilly"
  end
  
  def test_capitalize_name_with_leading_and_trailing_whitespace
    assert_capitalized ' josh ', 'Josh'
    assert_capitalized '     leonardo da vinci    ', 'Leonardo Da Vinci'
  end
  
  private 
  
  def assert_capitalized input, expected
    assert_equal input.capitalize_name, expected
  end
end