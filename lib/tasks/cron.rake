desc "This task is called by the Heroku cron add-on"
task cron: :environment do
  begin
    Rake::Task["crawl:studios"].invoke
  rescue => ex
    puts ex.message
    puts ex.backtrace
  end
  Rake::Task["crawl:classes"].invoke
end

namespace :crawl do
  desc "crawl studios"
  task studios: :environment do
    CrawlStudios.new.perform
  end

  desc "crawl classes"
  task classes: :environment do
    puts "crawling classes"
    CrawlClasses.new.perform
  end
end
