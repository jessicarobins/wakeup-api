class StationsController < ApplicationController
  before_action :set_station, only: [:show]

  # GET /stations
  def index
    @stations = Station.all

    render json: @stations
  end

  # GET /stations/1
  def show
    render json: @station.to_json(
      :methods => [
        :statistics,
        :last_bike_times
      ])
  end

  def show_by_route_name
    @station = Station.find_by!(:route_name => params[:id])
    
    render json: @station.to_json(
      :methods => [
        :statistics,
        :last_bike_times
      ])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def station_params
      params.fetch(:station, {})
    end
end
