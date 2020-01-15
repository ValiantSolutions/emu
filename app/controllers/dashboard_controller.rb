# frozen_string_literal: true

class DashboardController < ApplicationController
  breadcrumb 'Dashboard', '', match: :exact

  skip_after_action :verify_policy_scoped, only: [:index]
  skip_after_action :verify_authorized, only: %i[stats jumbotron]
  before_action :set_stats

  def index
    breadcrumb 'Overview & Status', dashboard_path, match: :exact
    job_timeline
  end

  def stats
    get_dashboard_stats

    respond_to do |format|
      format.js
    end
  end

  def jumbotron
    completed_jobs = Job.where(status: :completed).joins(:alert).where(alerts: {type: 'Permanent'}).group_by_hour(:created_at, last: 24, series: true, current: true)
    jumbo = [
      {
        name: 'Events Returned',
        data: completed_jobs.sum(:raw_event_count),
        color: 'rgb(227,231,237,0.3)',
        dataset: {borderColor: 'rgb(227,231,237,1.0)', spanGaps: true}
      },
      {
        name: 'Alertable Results',
        data: completed_jobs.sum(:actionable_event_count),
        color: '#00cccc',
        dataset: {spanGaps: true}
      }
    ]
    render json: jumbo.chart_json
  end

  def get_dashboard_stats
    job_latency
    guard_stats
    all_events_stats
    failed_job_stats
  end

  private

  def guard_stats
    guards = Guard.where(updated_at: 1.days.ago..@current_time)
    previous_guards = Guard.where(updated_at: 2.days.ago..1.days.ago)
    @stats[:events][:guards][:current] = guards.count
    @stats[:events][:guards][:duplicates_prevented] = Guard.all.sum(:hits) - Guard.all.count
    @stats[:events][:guards][:previous] = previous_guards.count

    @stats[:charts][:guards] = Guard.all.group_by_period(
      :hour,
      :created_at,
      format: '%s',
      last: 24,
    ).count.each_with_index.map do |(_k, v), i|
      [
        i, v
      ]
    end
  end

  def failed_job_stats
    @stats[:jobs][:failed][:current] = Job.where(updated_at: 7.days.ago..@current_time).where(status: :failed).count
    @stats[:jobs][:failed][:previous] = Job.where(updated_at: 14.days.ago..7.days.ago).where(status: :failed).count
  end

  def all_events_stats
    @stats[:events][:all_searched][:current] = Job.where(created_at: 1.days.ago..@current_time).where(
      status: :completed
    ).joins(:alert).where(alerts: {type: 'Permanent'}).sum(
      :raw_event_count
    ).to_i
    @stats[:events][:all_searched][:previous] = Job.where(created_at: 2.days.ago..1.days.ago).where(
      status: :completed
    ).joins(:alert).where(alerts: {type: 'Permanent'}).sum(
      :raw_event_count
    ).to_i
    @stats[:charts][:all_events] = Job.all.group_by_period(
      :hour,
      :created_at,
      format: '%s',
      last: 24
    ).joins(:alert).where(alerts: {type: 'Permanent'}).sum(:raw_event_count).each_with_index.map do |(_k, v), i|
      [
        i, v
      ]
    end
  end

  def actionable_events
    Job.where(created_at: 1.days.ago..@current_time).joins(:alert).where(alerts: {type: 'Permanent'}).sum(:actionable_event_count)
  end

  def job_latency
    job_times = Job.where(created_at: 1.days.ago..@current_time)&.map { |j| j.updated_at - j.created_at }
    previous_job_times = Job.where(created_at: 2.days.ago..1.days.ago)&.map { |j| j.updated_at - j.created_at }
    @stats[:jobs][:latency][:current] = (job_times&.sum / job_times&.size&.to_f).round(2)
    @stats[:jobs][:latency][:previous] = (previous_job_times&.sum / previous_job_times&.size&.to_f).round(2)
    @stats[:charts][:job_latency] = job_times&.each_with_index&.map { |v, i| [i, v] }
  end

  def job_timeline
    @job_timeline = Job.where(created_at: 1.days.ago..@current_time).where.not(actionable_event_count: 0).joins(:alert).where(alerts: {type: 'Permanent'}).limit(10).order(created_at: :desc)
  end

  def set_stats
    @stats = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc) }
    @current_time = Time.current

    @stats[:events][:actionable_event_count] = actionable_events
  end
end