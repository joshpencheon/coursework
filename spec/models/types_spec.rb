require File.dirname(__FILE__) + '/../spec_helper'

[Partnership, Region].each do |klass|
  describe klass do
    it "should load all partnerships from the YAML file without problems" do
      lambda { klass.populate }.should_not raise_error
      klass.count.should_not be_zero
    end
  end
end