require 'test_helper'

class LookupTest < Test::Unit::TestCase
  
  def setup
    @values = %w{ one two three }
    @keys = @values.map(&:upcase).map(&:to_sym)
    (0...@values.length).to_a.each do |i|
      Lookup.add(@keys[i], @values[i])
    end
  end
  
  def test_lookup_class_can_be_found
    assert_nothing_raised(NameError) { Lookup }
  end
  
  def test_filled_to_the_correct_length
    assert_equal Lookup.length, 3
  end
  
  def test_key_returns_correct_value
    assert_equal Lookup::ONE,   'one'
    assert_equal Lookup::TWO,   'two'
    assert_equal Lookup::THREE, 'three'
  end
  
  # Hash used internally, so with Ruby 1.8 
  # order isn't known for sure.
  def test_iteration
    keys, values = [], []
    Lookup.each do |key, value|
      keys   << key
      values << value
    end
    assert_equal_sorted @keys,   keys
    assert_equal_sorted @values, values
  end
  
  def test_lookup_failure_does_not_raise_exception
    assert_nothing_raised(NameError) { Lookup::FOO }
    assert_nil Lookup::FOO
  end
  
end