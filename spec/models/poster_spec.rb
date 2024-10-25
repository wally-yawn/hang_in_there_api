require 'rails_helper'

RSpec.describe Poster, type: :model do

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
end