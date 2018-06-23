require 'myfitnesspal_stats'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  today = Date.today
  daniel_scraper = Scraper.new(ENV.fetch('DANIEL_USERNAME'), ENV.fetch('DANIEL_PASSWORD'))
  daniel_today = daniel_scraper.get_date(today.year, today.month, today.day)

  send_event('daniel', { "value": rand(100), "moreinfo": daniel_today.nutrition_totals[:Calories][0] })
  send_event('lucy', { "value": rand(100) })
end
