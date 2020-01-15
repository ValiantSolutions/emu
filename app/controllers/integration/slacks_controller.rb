# frozen_string_literal: true

module Integration
  class SlacksController < Integration::BaseController

    before_action :set_slack, only: %i[show edit update destroy action]

    # GET /action/slacks
    # GET /action/slacks.json
    def index
      breadcrumb 'Slack Integrations', integration_slacks_path, match: :exact
      @slacks = policy_scope(Integration::Slack.all)
    end

    # GET /action/slacks/1
    # GET /action/slacks/1.json
    def show
      respond_to do |format|
        if @slack.is_valid?
          @slack.update!(status: :connectable)
          @slack.send_test_message
          format.html { redirect_to integration_slacks_path, notice: "Sent test message to #{@slack.channels}." }
        else
          @slack.update!(status: :unconnectable)
          flash[:alert] = "Unable to authenticate to #{@slack.name}"
          format.html { redirect_to integration_slacks_path }
        end
      end
    end

    # GET /action/slacks/new
    def new
      @slack = Slack.new
      breadcrumb 'Slack', integration_slacks_path, match: :exact
      breadcrumb 'New Slack Integration', new_integration_slack_path, match: :exact
    end

    # GET /action/slacks/1/edit
    def edit
      breadcrumb 'Slack', integration_slacks_path, match: :exact
      breadcrumb "Edit", '', match: :exact
      breadcrumb "#{@slack.name}", edit_integration_slack_path(@slack), match: :exact
    end

    # POST /action/slacks
    # POST /action/slacks.json
    def create
      @slack = Slack.new(slack_params)
      authorize @slack

      respond_to do |format|
        if @slack.save
          format.html { redirect_to integration_slacks_path, notice: "Slack integration #{@slack.name} was successfully created." }
          # format.json { render :show, status: :created, location: @slack }
        else
          format.html { render :new }
          # format.json { render json: @slack.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /action/slacks/1
    # PATCH/PUT /action/slacks/1.json
    def update
      respond_to do |format|
        params = slack_params
        #params[:status] = :valid
        params.delete :secret if params[:secret].blank?
        if @slack.update(params)
          format.html { redirect_to integration_slacks_path, notice: "#{@slack.name} was successfully updated." }
          # format.json { render :show, status: :ok, location: @slack }
        else
          format.html { render :edit }
          # format.json { render json: @slack.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /action/slacks/1
    # DELETE /action/slacks/1.json
    def destroy
      @slack.destroy
      respond_to do |format|
        format.html { redirect_to integration_slacks_path, notice: "#{@slack.name} was deleted successfully." }
        # format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_slack
      @slack = authorize Integration::Slack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slack_params
      dirty_params = params.require(:integration_slack).permit(
        :name,
        :client_id,
        :secret,
        :channels
      )
    
      if dirty_params.key?(:secret) && dirty_params[:secret].blank?
        dirty_params.delete :secret
      end
      dirty_params
    end
  end
end
