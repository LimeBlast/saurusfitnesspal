require 'myfitnesspal_stats'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|
  daniel = get_daniel
  lucy   = get_lucy

  send_event('daniel', { value: daniel[:value], moreinfo: daniel[:moreinfo] })
  send_event('lucy', { value: lucy[:value], moreinfo: lucy[:moreinfo] })
end

def get_daniel
  get_data Scraper.new(ENV.fetch('DANIEL_USERNAME'), ENV.fetch('DANIEL_PASSWORD'))
end

def get_lucy
  get_data Scraper.new(ENV.fetch('LUCY_USERNAME'), ENV.fetch('LUCY_PASSWORD'))
end

def get_data(scraper)
  data  = {}
  today = Date.today

  data[:today]     = scraper.get_date(today.year, today.month, today.day)
  data[:calories]  = data[:today].nutrition_totals.values[1] # horrible hack to get the value, because the scraper is out of date
  data[:eaten]     = data[:calories][0].delete(',').to_f
  data[:total]     = data[:calories][1].delete(',').to_f
  data[:remaining] = data[:calories][2].delete(',').to_f
  data[:value]     = ((data[:eaten] / data[:total]) * 100).to_i
  data[:moreinfo]  = "#{data[:eaten].to_i} / #{data[:total].to_i} calories"
  data
end
