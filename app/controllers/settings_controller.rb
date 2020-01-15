# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :set_settings, only: %i[update show]
  breadcrumb 'Administration', '', match: :exact

  def index
    breadcrumb 'Advanced Settings', settings_path, match: :exact

    @setting = policy_scope(Setting.all).last
    if @setting.nil? || @setting&.id != 1
      @setting = set_default_settings 
      flash[:notice] = 'Default settings installed.'
    end
  end

  def update
    respond_to do |format|
      if @setting.update(setting_param)
        format.html { redirect_to settings_path, notice: 'Settings updated.' }
      else
        format.html { render :index }
      end
    end
  end

  private

  def set_settings
    @setting = authorize Setting.find(params[:id])
  end

  def setting_param
    params.require(:setting).permit(:scroll_size, :debug_result_count, :inactive_account_age, :job_history_age)
  end

  def set_default_settings
    Setting.delete_all
    default_settings = Rails.application.config
    Setting.create!(
      scroll_size: default_settings.scroll_size,
      debug_result_count: default_settings.debug_result_count,
      inactive_account_age: default_settings.inactive_account_age,
      job_history_age: default_settings.job_history_age
    )
    Setting.last
  end
end