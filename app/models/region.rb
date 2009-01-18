class Region < ActiveRecord::Base
  has_many :studies, :dependent => :nullify
  
  default_scope :order => 'name'

  def self.populate
    YAML::load(File.open("#{RAILS_ROOT}/lib/regions.yaml")).values.each do |data|
      self.find_or_create_by_name(data.values.first)
    end
  end

end
