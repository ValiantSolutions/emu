# frozen_string_literal: true

class TemporariesController < AlertsController
  skip_after_action :verify_policy_scoped, only: :index
  breadcrumb 'Tools', '', match: :exact

  def index
    breadcrumb 'Event Debugger', temporaries_path, match: :exact

    if ElasticEndpoint.all&.count&.zero?
      flash[:alert] =  'You will have to define an Elasticsearch cluster before continuing.'
      redirect_to :elastic_endpoints
      return
    end
    @alert = Temporary.new
    @alert.build_search
    @alert.build_conditional
    @alert.build_payload
    3.times { @alert.actions.build }
  end

  def create
    @temporary = Temporary.new(alert_params)

    @temporary.user = current_user
    @temporary.search.user = current_user
    @temporary.search.name = "Search Preview #{rand(36**6).to_s(36)}"
    @temporary.search.indices = '_all'

    authorize @temporary
    
    respond_to do |format|
      if @temporary.save
        @job = Job.create!(alert: @temporary)
        format.js
      else
        format.js { render :errors }
      end
    end
  end

  private

  def alert_params
    strong_params = params.require(:temporary).permit(
      payload_attributes: [:body],
      conditional_attributes: [:body],
      search_attributes: %i[query elastic_endpoint_id],
      actions_attributes: %i[integratable_gid]
    )

    action_params = strong_params[:actions_attributes]

    action_params.each do |i, parm|
      strong_params[:actions_attributes].delete(i) if parm[:integratable_gid].blank?
    end
    strong_params
  end
end
