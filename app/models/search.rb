class Search 
  attr_reader :options

  def initialize(model, options)
    @model = model
    @options = options || {}
  end
  
  def name
    options[:name]
  end

  def education_level
    options[:education_level]
  end

  def event_date_after
    date_from_options(:event_date_after)
  end

  def event_date_before
    date_from_options(:event_date_before)
  end

  def has_name?
    name.present?
  end

  def has_address?
    address.present?
  end

  def conditions
    conditions = []
    parameters = []

    return nil if options.empty?
    
    if has_name?
      conditions << "#{@model.table_name}.name LIKE ?"
      parameters << "%#{name}%"
    end
    
    if has_address?
      conditions << "#{@model.table_name}.address LIKE ?"
      parameters << "%#{address}%"
    end

    if event_date_after
      conditions << "#{@model.table_name}.start_at >= ?"
      parameters << event_date_after.to_time
    end

    if event_date_before
      conditions << "#{@model.table_name}.end_at <= ?"
      parameters << event_date_before.to_time.end_of_day
    end

    unless conditions.empty?
      [conditions.join(" AND "), *parameters]
    else
      nil
    end
  end

  private

  def date_from_options(which)
      part = Proc.new { |n| options["#{which}(#{n}i)"] }
      y, m, d = part[1], part[2], part[3]
      y = Date.today.year if y.blank?
      Date.new(y.to_i, m.to_i, d.to_i)
    rescue ArgumentError => e
    return nil
  end
  
end