class Api::V1::PostersController < ApplicationController

  def post
    render json: Poster.create(poster_params)
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  def index
    posters = Poster.all
    render json: PosterSerializer.format_posters(posters)
  end
  
  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)
  end
  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end