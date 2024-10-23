class Poster < ApplicationRecord
  def self.min_price(amount)
    where("price > ?", amount)
  end

  def self.max_price(amount)
    where("price < ?", amount)
  end
end