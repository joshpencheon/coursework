class GeographicalRegionsTest < Test::Unit::TestCase
  EXPECTED_VALUES = [ 'North West', 'North East', 'East Midlands', 'West Midlands',
    'York and Humberside', 'East of England', 'London', 'South Central',
    'South Coast,', 'South West' ]
  EXPECTED_KEYS = EXPECTED_VALUES.map do |value|
    value.split(/ /).map(&:capitalize).join
  end
  
  def setup
    
  end
  
  def test_correct_keys
    actual_keys = GeographicalRegions.keys
    assert_equal_sorted EXPECTED_KEYS, actual_keys
  end
  
  def test_correct_regions
    actual_regions = GeographicalRegions.values
    assert_equal_sorted EXPECTED_VALUES, actual_regions
  end
end