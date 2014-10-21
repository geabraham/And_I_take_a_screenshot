desc "Generate config files using dice_bag's rake tasks"
task :release do
  Rake::Task['config:all'].invoke
end

task :build do
  Rake::Task['config:deploy'].invoke
  Rake::Task['assets:precompile'].invoke
end