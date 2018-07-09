class TimeCalc
  require 'active_support'
  require 'active_support/core_ext'

  attr_reader :total_time

  START_TIME = '9:00'
  FIRST_REST_END_TIME = '18:30'
  SECOND_REST_END_TIME = '22:00'
  SECOND_REST_START_TIME = '21:30'

  SECOND_REST_TOTAL_HOUR = 0.5

  def initialize
    @total_time = 0
  end

  def add_time(started_time, ended_time)
    before_start_time = over_worked_time_before_start_time(started_time)
    after_end_time = orver_worked_time_after_end_time(ended_time)
    @total_time += before_start_time + after_end_time
  end


  def over_worked_time_before_start_time(started_time)
    before_start_time = ("#{Date.today} #{START_TIME}".to_time - "#{Date.today} #{started_time}".to_time) / 3600
    before_start_time < 0 ? 0 : before_start_time
  end

  def orver_worked_time_after_end_time(ended_time)
    #18:00 - 18:30
    workted_time_after_first_rest = ("#{Date.today} #{ended_time}".to_time - "#{Date.today} #{FIRST_REST_END_TIME}".to_time) / 3600
    total_time = workted_time_after_first_rest < 0 ? 0 : workted_time_after_first_rest
    #21:30 - 22:00
    total_time -= if worked_after_second_rest?(ended_time)
                    # 22時以降勤務していた場合、休憩時間のため30分削減する。
                    SECOND_REST_TOTAL_HOUR
                  else
                    # 22時は超えず21:30 ~ 22:00の間勤務していた場合、休憩時間のため削減する。
                    wroked_time_during_second_rest(ended_time) > 0 ? wroked_time_during_second_rest(ended_time) : 0
                  end
    total_time
  end

  def worked_after_second_rest?(ended_time)
    (("#{Date.today} #{ended_time}".to_time - "#{Date.today} #{SECOND_REST_END_TIME}".to_time) / 3600) > 0
  end

  def wroked_time_during_second_rest(ended_time)
    ("#{Date.today} #{ended_time}".to_time - "#{Date.today} #{SECOND_REST_START_TIME}".to_time) / 3600
  end
end