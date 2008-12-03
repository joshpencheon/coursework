namespace :passenger do
  desc "Restart passenger"
  task :restart do
    puts 'Restarting Phusion Passenger...'
    file = File.join(RAILS_ROOT, 'tmp', 'restart.txt')
    system "touch #{file}"
    puts '**Done**'
  end
end