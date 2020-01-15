# frozen_string_literal: true

module DashboardHelper
  def human_readable_num(num)
    number_to_human(
      num,
      #number_with_delimiter(num, delimiter: ','),
      precision: 3,
      format: '%n%u',
      units: {
        thousand: 'K',
        million: 'M',
        billion: 'B',
        trillion: 'T'
      }
    )
  end

  def calc_max_for_flot_array(data)
    max_val = 0
    data&.each do |d|
      max_val = d.last if d.last > max_val
    end
    max_val.zero? ? 100 : max_val
  end

  def calc_min_for_flot_array(data)
    min_val = 0
    data&.each do |d|
      min_val = d.last if d.last < min_val
    end
    min_val.zero? ? -100 : min_val
  end

  def calc_pct_arrow(event, invert = false)
    previous = event[:previous]
    current = event[:current]
    
    return nil if previous.nil? || previous.zero?
    
    pct = {
      value: ((current / previous.to_f) * 100.0).round(2),
      arrow: current > previous ? 'up' : 'down'
    }
    pct[:color] = if invert
                    current > previous ? 'danger' : 'success'
                  else
                    current > previous ? 'success' : 'danger'
                  end

    return pct
  end
end