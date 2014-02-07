require "bundler/gem_tasks"

desc "Run tests"
task :default do
  system "bundle exec rspec"
end

desc "Load current gem in console"
task :console do
  cmd = "irb"
  sh "#{cmd} -I./lib -r 'aerogel/configurator'"
end