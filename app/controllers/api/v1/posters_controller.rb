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
    if params[:sort] == "desc"
      posters = Poster.all.order("created_at desc")
    elsif params[:sort] == "asc"
        posters = Poster.all.order("created_at asc")
    elsif params[:min_price]
      price = params[:min_price].to_i
      posters = Poster.where("price > ?", price)
    elsif params[:max_price]
      price = params[:max_price].to_i
      posters = Poster.where("price < ?", price)
    else 
      posters = Poster.all
    end
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