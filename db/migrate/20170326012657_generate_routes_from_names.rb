class GenerateRoutesFromNames < ActiveRecord::Migration[5.0]
  def change
    change_table :stations do |t|
      t.string :route_name
    end
    
    Station.all.each do |s|
      s.update!(:route_name => s.route_from_name)
    end
  end
end
