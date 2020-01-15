require 'rails_helper'

RSpec.describe Search, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :elastic_endpoint }
  
  it { is_expected.to have_many :alerts }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :elastic_endpoint_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :encrypted_indices }
  it { is_expected.to have_db_column :encrypted_indices_iv }
  it { is_expected.to have_db_column :encrypted_query }
  it { is_expected.to have_db_column :encrypted_query_iv }
  it { is_expected.to have_db_column :permanent }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["encrypted_indices_iv"] }
  it { is_expected.to have_db_index ["encrypted_query_iv"] }
  it { is_expected.to have_db_index ["elastic_endpoint_id"] }
  it { is_expected.to have_db_index ["user_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:user).with_message('must exist') }
  it { is_expected.to validate_presence_of(:elastic_endpoint).with_message('must exist') }
  it { is_expected.to validate_presence_of(:name).with_message('Please specify a name for this search.') }
  it { is_expected.to validate_presence_of(:indices).with_message('A search requires at least one index.') }
  it { is_expected.to validate_presence_of(:query).with_message('Enter a query') }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  

  describe 'validates search' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:search)).to be_valid
    end

    it 'has an invalid factory' do
      expect(Search.create(FactoryBot.attributes_for(:invalid_search))).to_not be_valid
    end

    it 'fails to create an invalid search' do
      expect(Search.create(FactoryBot.attributes_for(:search, query: ' '))).to_not be_valid
    end

    it 'splits the index list into an array' do
      @search = FactoryBot.create(:search, indices: 'my,index,list')
      expect(@search.index_array).to be_a(Array)
    end
  end
end