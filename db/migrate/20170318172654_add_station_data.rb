class AddStationData < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.transaction do
      resp = HTTParty.get("https://gbfs.capitalbikeshare.com/gbfs/en/station_information.json")
      stations = resp["data"]["stations"]
      
      stations.each do |s|
        Station.create!(
          :name => s["name"],
          :cabi_id => s["station_id"],
          :region_id => s["region_id"],
          :capacity => s["capacity"],
          :latitude => s["lat"],
          :longitude => s["lon"],
          :short_name => s["short_name"])
      end
    end
  end
  
  def down
    Station.destroy_all
  end
end
