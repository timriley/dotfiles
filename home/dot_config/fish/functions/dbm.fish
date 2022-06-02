function dbm --description 'bundle exec rake db:migrate shortcut'
  bundle exec rake db:migrate $argv
end
