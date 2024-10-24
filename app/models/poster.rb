class Poster < ApplicationRecord
  validates :name, :description, :year, :price, presence: true
  validate :vintage_presence


  def vintage_presence
    errors.add(:vintage, "can't be blank") if vintage.nil?
  end
end