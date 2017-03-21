class Transaction < ApplicationRecord
  belongs_to :station
  
  scope :for_station, ->(station_id) { where(:start_station_id => station_id) }
  scope :for_day, ->(day) { where("time BETWEEN ? AND ?", day.beginning_of_day, day.end_of_day)}
  
  scope :by_station, -> { order(:station_id) }
  scope :by_time, -> { order(:time) }
  
  DATE = "Start_date"
  STATION = "Start_station_number"
  
  def self.import(file:)
     
    ActiveRecord::Base.transaction do
      csv_text = File.read(file)
      csv = CSV.parse(csv_text, :headers => true)
      
      csv.each do |row|
        data = row.to_hash
        
        station = Station.find_by!(
          :short_name => data[STATION])
        
        Transaction.create!(
          :station_id => station.id,
          :time => format_time(:datetime => data[DATE])
        )
        puts "transaction for #{data[DATE]} created"
      end
    end
  end
  
  private
    def self.format_time(datetime:)
      DateTime.strptime(datetime, "%m/%d/%Y %k:%M")
    end
end
