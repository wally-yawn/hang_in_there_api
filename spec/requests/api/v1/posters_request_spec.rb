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

  describe "fetches posters" do
    before :each do
      @poster_1_id = Poster.create(name: "REGRET",
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id

      @poster_2_id = Poster.create(
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
      ).id
      @poster_3_id = Poster.create(
        name: "MEDIOCRITY",
        description: "Dreams are just that—dreams.",
        price: 127.00,
        year: 2021,
        vintage: false,
        img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
      ).id
    end

    it "sends a list of posters" do 
      get "/api/v1/posters"
      expect(response).to be_successful
      posters = JSON.parse(response.body)
      expect(posters["data"].count).to eq(3)
      expect(posters["meta"]["count"]).to eq(3)

      posters["data"].each do |poster|

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
  
    it "fetches a single poster" do
      get "/api/v1/posters/#{@poster_1_id}"
      expect(response).to be_successful
      poster = JSON.parse(response.body)
      # binding.pry
      expect(poster["data"]).to have_key("id")
      expect(poster["data"]["id"]).to be_an(Integer)

      expect(poster["data"]["attributes"]).to have_key("name")
      expect(poster["data"]["attributes"]["name"]).to be_a(String)

      expect(poster["data"]["attributes"]).to have_key("description")
      expect(poster["data"]["attributes"]["description"]).to be_a(String)

      expect(poster["data"]["attributes"]).to have_key("price")
      expect(poster["data"]["attributes"]["price"]).to be_a(Float)

      expect(poster["data"]["attributes"]).to have_key("year")
      expect(poster["data"]["attributes"]["year"]).to be_a(Integer)

      expect(poster["data"]["attributes"]).to have_key("vintage")
      expect(poster["data"]["attributes"]["vintage"]).to be(true).or be(false)

      expect(poster["data"]["attributes"]).to have_key("img_url")
      expect(poster["data"]["attributes"]["img_url"]).to be_a(String)

    end

    it "sends a list of posters in desc order by created_at" do
      get "/api/v1/posters?sort=desc"
      expect(response).to be_successful
      posters = JSON.parse(response.body)
      expect(posters["data"][0]["id"]).to eq(@poster_3_id)
      expect(posters["data"][1]["id"]).to eq(@poster_2_id)
      expect(posters["data"][2]["id"]).to eq(@poster_1_id)
    end

    it "sends a list of posters in asc order by created_at" do
      get "/api/v1/posters?sort=asc"
      expect(response).to be_successful
      posters = JSON.parse(response.body)
      expect(posters["data"][0]["id"]).to eq(@poster_1_id)
      expect(posters["data"][1]["id"]).to eq(@poster_2_id)
      expect(posters["data"][2]["id"]).to eq(@poster_3_id)
    end
  end

  it "can delete a poster" do
    poster = Poster.create(name: "Shark Bait", description: "Sharks Need To Eat Too!", price: 40.00, year: 2021, vintage: false, img_url: "https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp")

    expect(Poster.count).to eq(1)

    delete "/api/v1/posters/#{poster.id}"

    expect(response).to be_successful
    expect(Poster.count).to eq(0)
    expect{Poster.find(poster.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can filter posters by price' do
    poster1 = Poster.create(name: "Shark Bait", description: "Sharks Need To Eat Too!", price: 40.00, year: 2021, vintage: false, img_url: "https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp")

    poster2 = Poster.create(name: "Shark Hunter", description: "People Eating Sharks", price: 140.00, year: 1989, vintage: true, img_url: "https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp")

    expect(Poster.count).to eq(2)

    get "/api/v1/posters/?min_price=88.00"
    posters = JSON.parse(response.body)

    expect(response).to be_successful
    expect(posters["meta"]["count"]).to eq(1)
    expect(posters["data"][0]["attributes"]["name"]).to eq("Shark Hunter")
    
    get "/api/v1/posters/?max_price=88.00"
    posters = JSON.parse(response.body)

    expect(posters["meta"]["count"]).to eq(1)
    expect(posters["data"][0]["attributes"]["name"]).to eq("Shark Bait")
  end
end