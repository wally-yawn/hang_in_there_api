require 'rails_helper'

describe "Posters API" do
  it "can create a new poster" do
    poster_params = {
      name: "Shark Bait",
      description: "Sharks Need To Eat Too!",
      price: 40.00,
      year: 2021,
      vintage: false,
      img_url: "https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp"
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    created_poster = Poster.last

    expect(response).to be_successful
    expect(created_poster.name).to eq(poster_params[:name])
    expect(created_poster.description).to eq(poster_params[:description])
    expect(created_poster.price).to eq(poster_params[:price])
    expect(created_poster.year).to eq(poster_params[:year])
    expect(created_poster.vintage).to eq(poster_params[:vintage])
    expect(created_poster.img_url).to eq(poster_params[:img_url])
  end

  it "can update an exisiting poster" do
    id = Poster.create(name: "Shark Bait", description: "Sharks Need To Eat Too!", price: 40.00, year: 2021, vintage: false, img_url: "https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp").id
    old_poster_description = Poster.last.description
    poster_params = { description: "SCUBA Divers Taste Best!" }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
    poster = Poster.find_by(id: id)

    expect(response).to be_successful
    expect(poster.description).to_not eq(old_poster_description)
    expect(poster.description).to eq("SCUBA Divers Taste Best!")
  end

  describe "fetch all posters" do
    before :each do
      Poster.create(name: "REGRET",
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

      Poster.create(
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
      )
      Poster.create(
        name: "MEDIOCRITY",
        description: "Dreams are just that—dreams.",
        price: 127.00,
        year: 2021,
        vintage: false,
        img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
      )
    end

    it "sends a list of posters" do 
      get '/api/v1/posters'
      expect(response).to be_successful
      posters = JSON.parse(response.body)
      # binding.pry
      expect(posters["data"].count).to eq(3)

      posters["data"].each do |poster|
        # binding.pry
        expect(poster).to have_key("id")
        expect(poster["id"]).to be_an(Integer)

        expect(poster["attributes"]).to have_key("name")
        expect(poster["attributes"]["name"]).to be_a(String)

        expect(poster["attributes"]).to have_key("description")
        expect(poster["attributes"]["description"]).to be_a(String)

        expect(poster["attributes"]).to have_key("price")
        expect(poster["attributes"]["price"]).to be_a(Float)

        expect(poster["attributes"]).to have_key("year")
        expect(poster["attributes"]["year"]).to be_a(Integer)

        expect(poster["attributes"]).to have_key("vintage")
        expect(poster["attributes"]["vintage"]).to be(true).or be(false)

        expect(poster["attributes"]).to have_key("img_url")
        expect(poster["attributes"]["img_url"]).to be_a(String)
      end
    end
  end
end