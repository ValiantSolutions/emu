# frozen_string_literal: true

module Integration
  class Trello < Integration::Base
    self.table_name = 'integration_trellos'

    enum submit_step: %i[needs_boards has_boards]

    enum card_duplication: %i[
      always
      board_prevent_by_title
      board_prevent_by_description
      list_prevent_by_title
      list_prevent_by_description
    ]

    attribute :submit_step, default: :needs_boards
    attribute :board_list

    attr_encrypted :board_id,
                   key: Rails.application.credentials.attr_encrypted,
                   encode: true,
                   encode_iv: true,
                   marshal: true,
                   encode_salt: true
    attr_encrypted :token,
                   key: Rails.application.credentials.attr_encrypted,
                   encode: true,
                   encode_iv: true,
                   marshal: true,
                   encode_salt: true
    attr_encrypted :secret,
                   key: Rails.application.credentials.attr_encrypted,
                   encode: true,
                   encode_iv: true,
                   marshal: true,
                   encode_salt: true

    # has_many :actions
    has_many :logs, as: :loggable

    validate :credentials_valid?

    validates :name,
              format: {
                with: /\A[A-Za-z0-9 ]+\z/,
                message: 'Names may only contain alphanumeric and space characters.'
              },
              uniqueness: {
                message: 'An Trello integration already exists with that name. Please choose another.',
                case_sensitive: false
              },
              presence: {
                message: 'This field is required.'
              }

    validates :token,
              presence: {
                message: 'This field is required.'
              }

    validates :secret,
              presence: {
                message: 'API key & secret fields are required.'
              }

    validates :board_id,
              presence: {
                message: 'A Trello board is required.'
              }

    def boards!
      self.board_list = connection&.boards
      self.submit_step = board_list&.nil? || board_list&.empty? ? :needs_boards : :has_boards
      board_list
    end


    def connection
      @connection ||= Api::Trello.new(self) unless secret.blank? || token.blank?
    rescue StandardError => e
    end

    def board_name
      @board_name ||= connection&.board_name(board_id)
      @board_name.nil? ? 'Unknown/Missing' : @board_name
    end

    def board
      connection&.board(board_id)
    end

    def lists
      board&.lists
    end

    def cards
      board&.cards
    end

    def find_label_by_name(name)
      board&.labels&.each do |label|
        unless label.name.blank?
          return label if label&.name&.downcase&.eql?(name&.downcase)
        end
      end
      nil
    end

    def find_or_create_label_by_name(name)
      target_label = find_label_by_name(name)

      if target_label.nil? && create_labels
        valid_colors = %w[green yellow orange red purple blue sky lime pink black] << ''
        target_label = create_label(name, valid_colors.sample)
      end

      target_label
    end

    def find_list_by_name(name)
      board&.lists&.each do |lst|
        return lst if lst.name.downcase.eql?(name&.downcase)
      end
      nil
    end

    def find_or_create_list_by_name(name)
      target_list = find_list_by_name(name)
      target_list = create_list(name) if (target_list.nil? || target_list&.closed?) && create_lists

      target_list
    end

    def find_card_by_title(title)
      opts = {
        'idBoards' => board_id,
        'modelTypes' => 'cards',
        'card_fields' => 'name,closed,idList',
        'cards_limit' => 10,
        'cards_page' => 0,
        'card_board' => false,
        'card_list' => false,
        'card_members' => false,
        'card_stickers' => false,
        'card_attachments' => false
      }
      cards_hash = connection&.find(title, opts)

      cards_hash&.key?('cards') && cards_hash['cards']&.is_a?(Array) ? cards_hash['cards'] : nil
    end

    def create_list(list_name)
      connection&.create_list('name' => list_name, 'idBoard' => board_id)
    end

    def create_label(label_name, color)
      connection&.create_label('name' => label_name, 'idBoard' => board_id, 'color' => color)
    end

    def create_card(list_name, title, body, label = nil)
      return if list_name.nil? || title.nil?

      list_id = find_or_create_list_by_name(list_name)&.id

      return if list_id.nil?

      return unless create_card?(title, body, list_id)

      label_id = find_or_create_label_by_name(label)&.id unless label.nil?

      return false if list_id.nil?

      card_options = {
        'name' => title,
        'desc' => body,
        'idList' => list_id
      }
      card_options['idLabels'] = label_id unless label_id.nil?
      connection&.create_card(card_options)
    end

    def create_test_card
      return true if Rails.env.test?
      list_id = if lists&.empty?
                  create_list('EMU Test List')&.id
                else
                  lists&.first&.id
                end

      card_options = {
        'name' => 'EMU Test Card',
        'idList' => list_id,
        'desc' => "Hello World!\n~emu"
      }
      connection&.create_card(card_options)
    end

    def credentials_valid?
      return true if Rails.env.test?
      return true unless connection.nil?
      errors.add(:base, 'Invalid credentials')
      false
    end

    private

    def create_card?(title, body, list_id)
      return true if always?
      return !card_exists_in_board?(title, body) if board_prevent_by_title? || board_prevent_by_description?
      return !card_exists_in_list?(title, body, list_id) if list_prevent_by_title? || list_prevent_by_description?
    end

    def card_exists_in_board?(title, body)
      cards&.each do |c|
        if board_prevent_by_title?
          if c&.name&.downcase&.eql?(title&.downcase)
            next if c&.closed?
            card_list = connection&.get_list_by_id(c&.list_id)
            return true unless card_list.closed?
          end
        elsif board_prevent_by_description?
          if c&.desc&.downcase&.eql?(body&.downcase)
            next if c&.closed?
            card_list = connection&.get_list_by_id(c&.list_id)
            return true unless card_list&.closed?
          end
        end
      end
      false
    end

    def card_exists_in_list?(title, body, list_id)
      list = connection&.get_list_by_id(list_id)
      return false if list.nil? || list&.closed?

      list&.cards&.each do |c|
        if list_prevent_by_title?
          if c&.name&.downcase&.eql?(title&.downcase)
            return true unless c&.closed?
          end
        elsif list_prevent_by_description?
          if c&.desc.downcase&.eql?(body&.downcase)
            return true unless c&.closed?
          end
        end
      end
      false
    end
  end
end