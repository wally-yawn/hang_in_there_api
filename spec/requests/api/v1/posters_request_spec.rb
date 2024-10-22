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
end