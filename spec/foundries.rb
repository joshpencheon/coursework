Foundry.setup_foundries do
  model Study do
    factory :valid do
      { :title          => 'My special study', 
        :description    => 'It is really interesting.' ,
        :partnership_id => 1 ,
        :region_id      => 1,
        :category       => 'Travel' }
    end 
  end
  
  model AttachedFile do
    factory :text do
      { :document => File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'text.txt')) }
    end
    
    factory :image do
      { :document => File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'jpeg.jpeg')) }
    end
    
    factory :archive do
      { :document => File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'zip.zip')) }
    end
    
    factory :excel do
      { :document => File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'msexcel.xls')) }
    end
    
    factory :unusual do
      { :document => File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'bash.sh')) }
    end
  end
  
  model User do
    factory :valid do
      { :login                 => Faker::Name.send(:first_name),
        :email                 => Faker::Internet.send(:email),
        :password              => 'secret',
        :password_confirmation => 'secret' }
    end
    
    factory :verbose do
      { :first_name => 'Josh',
        :last_name  => 'Bloggs',
        :bio        => 'It is only me.' }
    end
    
    factory :admin do
      { :admin => true }
    end
  end
  
  model Event do
    factory :valid do
      { :news_item_id   => Study.valid.create!.id,
        :news_item_type => 'Study' }
    end
  end
end