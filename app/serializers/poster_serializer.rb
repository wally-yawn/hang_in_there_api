class PosterSerializer
  def self.format_posters(posters)
    posters_data = posters.map do |poster|
      # binding.pry
      {
      id: poster.id,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
        }
      }
    end
    {data: posters_data,
    meta: {
      count: posters_data.count}
  }
  end

  def self.format_poster(poster)
    {data: {
      id: poster.id,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
        }
      }
    }
  end
end