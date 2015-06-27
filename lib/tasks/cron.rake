desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  Rake::Task["crawl:studios"].invoke
  Rake::Task["crawl:classes"].invoke
end

namespace :crawl do
  desc "crawl studios"
  task :studios => :environment do
    Studio.crawl_studios
  end

  desc "crawl classes"
  task :classes => :environment do
    Studio.crawl_classes
  end
end
