class Api::V1::PostersController < ApplicationController

  def post
    createPoster = Poster.create(poster_params)
    render json: PosterSerializer.format_poster(createPoster)
  end

  def update
    updatePoster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.format_poster(updatePoster)
  end

  def index
    posters = Poster.filter_and_sort(params)
    render json: PosterSerializer.format_posters(posters)
  end
  
  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end
  
  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end