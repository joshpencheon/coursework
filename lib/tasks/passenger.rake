namespace :passenger do
  desc "Restart passenger"
  task :restart do
    puts 'Restarting Phusion Passenger...'
    
    FileUtils.cd(RAILS_ROOT) do
      FileUtils.mkdir('tmp') unless File.exists?('tmp')
      file = File.join('tmp', 'restart.txt')
      system "touch #{file}"
    end
    
    puts '**Done**'
  end
end