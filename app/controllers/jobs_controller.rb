# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :set_job, only: %i[show]

  def show
    respond_to do |format|
      if @job&.completed?
        @alert_type = @job&.alert&.type
        format.js { render :complete }
      else
        format.js { render :show }
      end
    end
  end

  private

  def set_job
    @job = authorize Job.find(params[:id])
  end
end
