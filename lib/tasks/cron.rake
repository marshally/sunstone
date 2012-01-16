desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  Studio.crawl_studios
  Studio.crawl_classes
end