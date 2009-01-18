class Partnership < ActiveRecord::Base
  has_many :studies, :dependent => :nullify

  def self.populate
    YAML::load(File.open("#{RAILS_ROOT}/lib/partnerships.yaml")).values.each do |data|
      self.find_or_create_by_name(data.values.first)
    end
  end

end