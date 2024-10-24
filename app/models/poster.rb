class Poster < ApplicationRecord
  validates :name, :description, :year, :price, presence: true
  validate :vintage_presence

  def self.filter_and_sort(params)
    posters = Poster.all

    if params[:sort] == "desc"
      posters = posters.order("created_at desc")
    elsif  params[:sort] == "asc"
      posters = posters.order("created_at asc")
    end

    if params[:min_price]
      price = params[:min_price].to_i
      posters = posters.where("price > ?", price)
    elsif params[:max_price]
      price = params[:max_price].to_i
      posters = posters.where("price < ?", price)
    end

    if params[:name]
      nameFragment = params[:name]
      posters = posters.where("LOWER(name) like ?", "%#{nameFragment.downcase}%").order("LOWER(name)")
    end
    posters
  end
  def vintage_presence
    errors.add(:vintage, "can't be blank") if vintage.nil?
  end
end