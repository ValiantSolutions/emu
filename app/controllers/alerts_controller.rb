# frozen_string_literal: true

class AlertsController < ApplicationController
  before_action :set_alert, only: %i[show edit update destroy]
  skip_after_action :verify_authorized, only: [:tips]
  

  def tips
    @show = params[:show]
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_alert
    @alert = authorize Alert.find(params[:id])
  end
end
