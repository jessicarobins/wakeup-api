require 'csv'
require 'date'

class Trip < ApplicationRecord
  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"
  
  validates :start_time, uniqueness: { scope: :bike_number }
  
  scope :for_station, ->(station_id) { where(:start_station_id => station_id) }
  scope :for_day, ->(day) { where("start BETWEEN ? AND ?", day.beginning_of_day, day.end_of_day)}
  
  
  START_DATE = "Start date"
  END_DATE = "End date"
  START_STATION = "Start station number"
  END_STATION = "End station number"
  BIKE_NUMBER = "Bike number"
  
  def self.import_trips(file:)
    ActiveRecord::Base.transaction do
      csv_text = File.read(file)
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        data = row.to_hash
        
        start_station = Station.find_by!(
          :short_name => data[START_STATION])
        
        end_station = Station.find_by!(
          :short_name => data[END_STATION])
        
        Trip.create!(
          :start_station_id => start_station.id,
          :end_station_id => end_station.id,
          :bike_number => data[BIKE_NUMBER],
          :start_time => format_time(:datetime => data[START_DATE]),
          :end_time => format_time(:datetime => data[END_DATE])
        )
      end
    end
  end
  
  private
    def self.format_time(datetime:)
      DateTime.strptime(datetime, "%m/%d/%Y %k:%M")
    end
end
