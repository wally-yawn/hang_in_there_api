class Api::V1::PostersController < ApplicationController

  def post
    render json: Poster.create(poster_params)
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end