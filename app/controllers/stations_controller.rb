class StationsController < ApplicationController
  before_action :set_station, only: [:show]

  # GET /stations
  def index
    @stations = Station.all

    render json: @stations.to_json(
      :methods => [
        :median_last_bike,
        :find_last_bike_by_day
      ])
  end

  # GET /stations/1
  def show
    render json: @station.to_json(
      :methods => [
        :median_last_bike,
        :find_last_bike_by_day
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
