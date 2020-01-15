# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticEndpoint, regressor: true do
  # === Relations ===
  it { should belong_to(:user) }

  it { is_expected.to have_many :searches }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :protocol }
  it { is_expected.to have_db_column :verify_ssl }
  it { is_expected.to have_db_column :port }
  it { is_expected.to have_db_column :encrypted_address }
  it { is_expected.to have_db_column :encrypted_username }
  it { is_expected.to have_db_column :encrypted_password }
  it { is_expected.to have_db_column :encrypted_address_iv }
  it { is_expected.to have_db_column :encrypted_username_iv }
  it { is_expected.to have_db_column :encrypted_password_iv }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['encrypted_address_iv'] }
  it { is_expected.to have_db_index ['encrypted_username_iv'] }
  it { is_expected.to have_db_index ['encrypted_password_iv'] }
  it { is_expected.to have_db_index ['user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:name).with_message('Specify a name for this cluster.') }
  it { is_expected.to validate_presence_of(:address).with_message('Specifiy address in either FQDN format (my.domain.name.com) or a valid IP address (1.2.3.4)') }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:port).only_integer.with_message('Specifiy a port number between 1 and 65535.') }
  it { is_expected.to validate_numericality_of(:port).is_greater_than(0).with_message('Specifiy a port number between 1 and 65535.') }
  it { is_expected.not_to validate_numericality_of(:port).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:port).is_less_than_or_equal_to(65_535).with_message('Specifiy a port number between 1 and 65535.') }
  it { is_expected.not_to validate_numericality_of(:port).is_less_than_or_equal_to(65_536) }
  it { is_expected.to validate_numericality_of(:port).with_message('Specifiy a port number between 1 and 65535.') }

  # === Enums ===
  it { is_expected.to define_enum_for(:protocol).with_values(%w[https http]) }
  it { is_expected.to define_enum_for(:status).with_values(%w[connectable unconnectable unknown]) }

  context 'validates ElasticEndpoint' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:elastic_endpoint)).to be_valid
    end

    it 'has an invalid factory' do
      expect(ElasticEndpoint.create(FactoryBot.attributes_for(:invalid_elastic_endpoint))).to_not be_valid
    end
  end

  context 'cleans user data' do
    it 'validates the port number' do
      expect(ElasticEndpoint.create(FactoryBot.attributes_for(:elastic_endpoint, port: 100_000_000))).to_not be_valid
    end

    it 'validates the endpoint address' do
      expect(ElasticEndpoint.create(FactoryBot.attributes_for(:elastic_endpoint, address: '-'))).to_not be_valid
    end
  end

  context 'misc model functions' do
    it 'assembles a connection string with the username and password' do
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
      expect(@elastic_endpoint.build_connection_string).to eq('https://elastic:myelasticpassword@elasticsearch.endpoint.com:9243')
    end

    it 'assembles a connection string without the username and password' do
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint, username: nil, password: 'mytestpass')
      expect(@elastic_endpoint.build_connection_string).to eq('https://elasticsearch.endpoint.com:9243')
    end

    it 'assembles a connection string with a blank password' do
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint, password: ' ')
      expect(@elastic_endpoint.build_connection_string).to eq('https://elasticsearch.endpoint.com:9243')
    end
  end
end