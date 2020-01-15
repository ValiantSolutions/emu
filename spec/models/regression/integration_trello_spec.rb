require 'rails_helper'

RSpec.describe Integration::Trello, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :actions }
  it { is_expected.to have_many :alerts }
  it { is_expected.to have_many :logs }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :encrypted_token }
  it { is_expected.to have_db_column :encrypted_token_iv }
  it { is_expected.to have_db_column :encrypted_secret_iv }
  it { is_expected.to have_db_column :encrypted_secret }
  it { is_expected.to have_db_column :encrypted_board_id }
  it { is_expected.to have_db_column :encrypted_board_id_iv }
  it { is_expected.to have_db_column :create_labels }
  it { is_expected.to have_db_column :create_lists }
  it { is_expected.to have_db_column :card_duplication }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["encrypted_board_id_iv"] }
  it { is_expected.to have_db_index ["encrypted_secret_iv"] }
  it { is_expected.to have_db_index ["encrypted_token_iv"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:name).with_message('This field is required.') }
  it { is_expected.to validate_presence_of(:token).with_message('This field is required.') }
  it { is_expected.to validate_presence_of(:secret).with_message('API key & secret fields are required.') }
  it { is_expected.to validate_presence_of(:board_id).with_message('A Trello board is required.') }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  #it { is_expected.to define_enum_for(:submit_step).with_values(["needs_boards", "has_boards"]) }
  it { is_expected.to define_enum_for(:card_duplication).with_values(["always", "board_prevent_by_title", "board_prevent_by_description", "list_prevent_by_title", "list_prevent_by_description"]) }
  
end