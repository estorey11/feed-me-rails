class SearchesController < ApplicationController

  def create
    @search=Search.create(search_params)
    render json: @search, status: 201
  end

  def show
    @search=Search.find_by(id: params[:id])
    render json: @search
  end

  def index
    @searches=Search.all
    render json: @searches
  end


  private

  def search_params
    params.require(:search).permit(
      :address1,
      :address2,
      :city,
      :state,
      :zip,
      :restaurant)
  end
end
