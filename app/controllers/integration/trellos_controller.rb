# frozen_string_literal: true

module Integration
  class TrellosController < Integration::BaseController
    before_action :set_integration_trello, only: %i[show edit update destroy]

    # GET /integration/trellos
    # GET /integration/trellos.json
    def index
      
      breadcrumb 'Trello Integrations', integration_trellos_path, match: :exact
      @trellos = policy_scope(Integration::Trello.all)
    end

    # GET /integration/trellos/1
    # GET /integration/trellos/1.json
    def show
      respond_to do |format|
        if @trello.credentials_valid? && @trello.create_test_card
          format.html { redirect_to integration_trellos_path, notice: "Created test card for board #{@trello.board_name}." }
        else
          flash[:alert] = "Unable to create test card for #{@trello.name}. Does a list exist?"
          format.html { redirect_to integration_trellos_path }
        end
      end
    end

    # GET /integration/trellos/new
    def new
      breadcrumb 'Trello', integration_trellos_path, match: :exact
      breadcrumb 'New Trello Integration', new_integration_trello_path, match: :exact

      @trello = Integration::Trello.new
    end

    # GET /integration/trellos/1/edit
    def edit
      breadcrumb 'Trello', integration_trellos_path, match: :exact
      breadcrumb "Edit", '', match: :exact
      breadcrumb "#{@trello.name}", edit_integration_trello_path(@trello), match: :exact
      @trello.boards!
    end

    # POST /integration/trellos
    # POST /integration/trellos.json
    def create
      @trello = authorize Integration::Trello.new(integration_trello_params)

      if @trello.board_id.nil?
        @trello.boards!
        if @trello.credentials_valid?
          respond_to do |format|
            format.js { render :new }
          end
        end

      else
        respond_to do |format|
          if @trello.save
            flash[:notice] = "#{@trello.name} was successfully created."
            format.js do
              render js: "window.location='#{integration_trellos_url}'"
            end
            format.html { redirect_to integration_trellos_url }
          else
            format.html { render :new }
            format.js { render :errors }
          end
        end
      end
    end

    # PATCH/PUT /integration/trellos/1
    # PATCH/PUT /integration/trellos/1.json
    def update
      respond_to do |format|
        params = integration_trello_params
        params.delete :token if params[:token].blank?
        params.delete :secret if params[:secret].blank?

        if @trello.update(params)
          flash[:notice] = "#{@trello.name} was successfully updated." 
          format.js do
            render js: "window.location='#{integration_trellos_url}'"
          end
          format.html { redirect_to integration_trellos_url }
        else
          format.js { render :errors }
          format.html { render :edit }
        end
      end
    end

    # DELETE /integration/trellos/1
    # DELETE /integration/trellos/1.json
    def destroy
      @trello.destroy
      respond_to do |format|
        format.html { redirect_to integration_trellos_url, notice: "#{@trello.name} was deleted successfully." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_integration_trello
      @trello = authorize Integration::Trello.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def integration_trello_params
      dirty_params = params.require(:integration_trello).permit(
        :name,
        :token,
        :secret,
        :board_id,
        :submit_step,
        :card_duplication,
        :create_lists,
        :create_labels
      )
    
      if dirty_params.key?(:secret) && dirty_params[:secret].blank?
        dirty_params.delete :secret
      end
      dirty_params
    end
  end
end
