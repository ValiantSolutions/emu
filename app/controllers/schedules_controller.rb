# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show edit update destroy trigger]

  breadcrumb 'Scheduling', '', match: :exact

  # GET /schedules
  # GET /schedules.json
  def index
    breadcrumb 'Schedule Management', schedules_path, match: :exact
    @schedules = policy_scope(Schedule.all)

    # if Alert.all.count.zero?
    #   flash[:alert] = 'No alerts defined. Create one first.'
    #   redirect_to new_permanent_path
    #   return
    # end
    # redirect_to new_schedule_path, notice: 'No schedules to show yet; create one here.' if @schedules.empty?
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show; end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
    breadcrumb 'New Schedule', new_schedule_path, match: :exact

    if policy_scope(Alert.all).count.zero?
      flash[:alert] = 'No alerts defined. Create one first.'
      redirect_to new_permanent_path
      return
    end
  end

  # GET /schedules/1/edit
  def edit; end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user

    authorize @schedule

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to schedules_path, notice: 'Schedule was successfully created.' }
        # format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        # format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to schedules_path, notice: "Schedule for #{@schedule.alert.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def trigger
    @schedule.run_job
    head :ok
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: "Schedule for #{@schedule.alert.name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = authorize Schedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def schedule_params
    params.require(:schedule).permit(:cron, :period, :range, :alert_id, :enabled)
  end
end
