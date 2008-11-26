require File.dirname(__FILE__) + '/../spec_helper'
  
describe Lookup, 'when three values are entered' do
  before(:each) do
    @values = %w{ one two three }
    @keys = @values.map(&:upcase).map(&:to_sym)
    (0...@values.length).to_a.each do |i|
      Lookup.add(@keys[i], @values[i])
    end
  end

  it 'should return the number of items when #length is called' do
    Lookup.length.should == 3
  end

  it 'should return the correct value when class constant is called' do
    Lookup::ONE.should   == 'one'
    Lookup::TWO.should   == 'two'
    Lookup::THREE.should == 'three'
  end

  it 'should iterate through the values correctly' do
    keys, values = [], []
    Lookup.each do |key, value|
      keys   << key
      values << value
    end
    (@keys - keys).should be_empty
    (keys - @keys).should be_empty
    (@values - values).should be_empty
    (values - @values).should be_empty
  end
  
  context 'when an unknown constant is called' do
    it "should not raise an error" do
      lambda { Lookup::SOME_UNKNOWN_CONSTANT }.should_not raise_error(NameError)
    end
    
    it 'should return nil' do
      Lookup::SOME_UNKNOWN_CONSTANT.should be_nil
    end
  end  
end