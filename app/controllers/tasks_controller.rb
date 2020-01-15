# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[update show]
  breadcrumb 'Administration', '', match: :exact

  def index
    breadcrumb 'Maintenance Jobs', tasks_path, match: :exact
    
    @tasks = policy_scope(Task.all)
    if @tasks&.count&.zero?
      @tasks = setup_default_tasks 
      flash[:notice] = 'Maintenance jobs installed successfully.'
    end 
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
      else
        format.html { render :index }
      end
    end
  end

  def show
    @task.enqueue
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Task was enqueued.' }
    end
  end

  private

  def set_task
    @task = authorize Task.find(params[:id])
  end

  def task_params
    if params.key?(:task_failed_job)
      params.require(:task_failed_job).permit(:cron, :enabled)
    elsif params.key?(:task_inactive_account)
      params.require(:task_inactive_account).permit(:cron, :enabled)
    end
  end

  def setup_default_tasks
    namespaced_tasks = Task.constants.select {|c| Task.const_get(c).is_a?(Class) && Task.const_get(c).to_s.include?('Policy')}.map { |t| t.to_s.sub('Policy', '')}
    namespaced_tasks.each do |t|
      "Task::#{t}".constantize.create!(cron: Rails.application.config.default_cron, enabled: true)
    end
    policy_scope(Task.all)
  end
end