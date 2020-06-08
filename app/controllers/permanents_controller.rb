# frozen_string_literal: true

class PermanentsController < AlertsController
  before_action :set_integrations, only: %i[new update edit create]
  before_action :set_alert, only: %i[show edit update destroy enable disable]

  breadcrumb 'Alerting', '', match: :exact

  def index
    breadcrumb 'Alert Overview', permanents_path, match: :exact
    @alerts = policy_scope(Permanent.all)
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    breadcrumb 'Job History', '', match: :exact
    breadcrumb @alert.name, permanent_path(@alert), match: :exact
  end

  # GET /alerts/new
  def new
    breadcrumb 'Create New Alert', new_permanent_path, match: :exact

    # if ElasticEndpoint.all.empty?
    #   flash[:alert] = 'An Elasticsearch cluster must be defined prior to creating an alert!'
    #   redirect_to :elastic_endpoints
    #   return
    # end

    # if Search.where(permanent: true).empty?
    #   flash[:alert] = 'A search must be saved prior to creating an alert!'
    #   redirect_to :new_search
    #   return
    # end
    if !ElasticEndpoint.all.empty? && !Search.where(permanent: true).empty?
      @alert = Permanent.new
      @alert.build_conditional
      @alert.build_payload
      3.times { @alert.actions << Action.new }
    end
  end

  # GET /alerts/1/edit
  def edit
    breadcrumb 'Edit', permanents_path, match: :exact
    breadcrumb @alert.name.to_s, edit_permanent_path(@alert), match: :exact

    (0..2 - @alert.actions.count).each do
      @alert.actions << Action.new
    end
  end

  def disable
    @alert&.schedules&.each do |s|
      s.update!(enabled: false)
    end

    respond_to do |format|
      format.html { redirect_to permanents_path, notice: "Schedules referencing #{@alert.name} have been disabled." }
    end
  end

  def enable
    @alert&.schedules&.each do |s|
      s.update!(enabled: true)
    end

    respond_to do |format|
      format.html { redirect_to permanents_path, notice: "All schedules referencing #{@alert.name} have been enabled." }
    end
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Permanent.new(alert_params)
    @alert.user = current_user

    authorize @alert

    respond_to do |format|
      if @alert.save
        format.html { redirect_to permanents_path, notice: 'Alert was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to permanents_path, notice: "#{@alert.name} was successfully updated." }
        format.js { head :ok }
        # format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.js { head :unprocessable_entity }
        # format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to permanents_path, notice: "#{@alert.name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  private

  def set_integrations
    @slacks = Integration::Slack.all
    @trellos = Integration::Trello.all
    @emails = Integration::Email.all
  end

  def alert_params
    params.require(:permanent).permit(
      :name,
      :id,
      :search_id,
      :deduplication,
      :deduplication_fields,
      payload_attributes: %i[body id],
      conditional_attributes: %i[body id],
      actions_attributes: %i[integratable_gid id enabled]
    )
  end
end
