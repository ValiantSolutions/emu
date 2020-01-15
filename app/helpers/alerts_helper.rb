# frozen_string_literal: true

module AlertsHelper
  def valid_actions?
    @slack_count = @slacks&.count
    @email_count = @emails&.count
    @trello_count = @trellos&.count

    if (@slack_count.nil? && @trello_count.nil? && @email_count.nil?) || (@slack_count + @trello_count + @email_count <= 0)
      false
    else
      true
    end
  end

  def debug_conditional_against_results(job)
    conditional_results = []

    raw_events = JSON.parse(job&.alert&.conditional&.log&.body)

    return nil if raw_events.nil?

    actionable_events = job.alert.conditional.actionable_events(job, raw_events, false)

    actionable_set = actionable_events.to_set
    raw_set = raw_events.to_set

    failed_conditional_events = raw_set - actionable_set

    actionable_events.each do |a|
      conditional_results.push(event: a, outcome: true)
    end

    failed_conditional_events.each do |f|
      conditional_results.push(event: f, outcome: false)
    end

    conditional_results
  end

  def schedules_disabled?(alert)
    alert&.schedules&.where(enabled: false)&.count == alert&.schedules&.count
  end

  def log_icon(log)
    log_type = log.loggable_type.split('::').last.downcase
    if log_type.eql?('email')
      'mail'
    elsif log_type.eql?('debug')
      'eye'
    else
      log_type
    end
  end

  def log_title(log)
    title = (log&.loggable_type&.split('::')&.last).to_s
    title = "#{title} [Subject: #{log&.subject}]" unless log&.subject.nil?
    title
  end

  def humanize_duplication_enum(alert)
    if alert.deduplicate_on_event_id?
      'Prevents duplicates by checking if the unique document ID has been processed in the past.'
    elsif alert.deduplicate_on_event_content?
      "Calculates a hash of the following fields: <span class='tx-pink tx-roboto-mono tx-12'>#{alert.deduplication_fields.split(',').join(', ')}</span>.".html_safe
    else
      'Does not prevent duplicate alerts.'
    end
  end

  def last_alert_execution(alert)
    last_job = Job&.where(alert: alert)&.order(created_at: :desc)&.limit(1)&.last
    last_job&.schedule&.last&.in_time_zone(@user_tz)&.strftime('%m/%d/%Y @ %I:%M:%S%p') unless last_job.nil?
  end

  def generate_alert_raw_event_chart(alert)
    Job&.where(alert: alert)&.group_by_hour(:created_at, last: 48, series: true, current: true)&.sum(:raw_event_count)&.each_with_index&.map do |(k, v), _i|
      {
        't' => k,
        'y' => v
      }
    end
  end

  def generate_alert_actionable_event_chart(alert)
    Job&.where(alert: alert)&.group_by_hour(:created_at, last: 48, series: true, current: true)&.sum(:actionable_event_count)&.each_with_index&.map do |(k, v), _i|
      {
        't' => k,
        'y' => v
      }
    end
  end

  def alert_chart_max(alert)
    max = Job&.where(alert: alert)&.where(updated_at: 2.days.ago..Time.now)&.maximum(:raw_event_count)
    max
  end

  def alert_chart_options
    {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        display: false,
        labels: {
          display: false
        }
      },
      ticks: {
        display: false
      },
      hover: {
        mode: 'index',
        intersect: true
      },
      tooltips: {
        mode: 'index',
        intersect: true,
        position: 'nearest',
        bodyFontFamily: '-apple-system, BlinkMacSystemFont, "Inter UI", Roboto, sans-serif'
      },
      elements: {
        point: {
          radius: 0,
          hoverRadius: 3,
          pointStyle: 'circle'
        },
        line: {
          # tension: 0.25,
          # borderWidth: 0.25,
          fill: true,
          fillColor: '#FF0000'
        }
      },
      scales: {
        xAxes: [{
          type: 'time',
          # distribution: 'series',
          time: {
            unit: 'hour'
          },
          gridLines: {
            # color: '#e5e9f2',
            drawOnChartArea: false,
            # zeroLineColor: 'rgba(50,58,78,0.0)',
            display: false,
            zeroLineWidth: 0,
            drawBorder: true
          },
          ticks: {
            display: false,
            # fontColor: '#8392a5',
            fontSize: 10,
            fontStyle: '500',
            fontFamily: '-apple-system, BlinkMacSystemFont, "Inter UI", Roboto, sans-serif',
            maxTicksLimit: 5
          }
        }],
        yAxes: [{
          type: 'logarithmic',
          gridLines: {
            # color: '#ebeef3',
            display: false,
            zeroLineWidth: 0,
            zeroLineColor: 'rgba(50,58,78,0.0)',
            drawBorder: false
          },
          ticks: {
            display: false,
            # fontColor: '#8392a5',
            fontSize: 10,
            fontStyle: '500',
            fontFamily: '-apple-system, BlinkMacSystemFont, "Inter UI", Roboto, sans-serif',
            maxTicksLimit: 7
          }
        }]
      }
    }
  end
end
