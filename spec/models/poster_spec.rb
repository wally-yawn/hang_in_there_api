require 'rails_helper'

RSpec.describe Poster, type: :model do
  # Test routes
  # it { should route (:get, '/api/v1/posters').to(action: :index) }
  # it { should route (:get, '/api/v1/posters/1').to(action: :show, id: 1) }
  # it { should route (:post, '/api/v1/posters').to(action: :post) }
  # it { should route (:patch, '/api/v1/posters/1').to(action: :update, id: 1) }
  # it { should route (:delete, '/api/v1/posters/1').to(action: :destroy, id: 1) }

  # Test validations
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should validate_presence_of(:year) }
  it { should validate_numericality_of(:year).only_integer }
  it { should validate_presence_of(:vintage) }
  it { should validate_presence_of(:img_url) }

  # Test serializer
  it { should serialize(:posters).as(PosterSerializer) }

  # RSpec.describe PostersController, type: controller do
  # # Test validating parameters
  #   it do
  #     params = {
  #       poster: {
  #         name: 'Shark Bait',
  #         description: 'Sharks Need to Eat Too!',
  #         price: 40.00,
  #         year: 2021,
  #         vintage: false,
  #         img_url: 'https://i.ebayimg.com/images/g/oXoAAOSwOAFmqZsG/s-l1600.webp'
  #       }
  #     }
  #     should permit(:name, :description, :price, :year, :vintage, :img_url).
  #       for(:create, params: params).
  #       on(:book)
  #   end
  # end
end