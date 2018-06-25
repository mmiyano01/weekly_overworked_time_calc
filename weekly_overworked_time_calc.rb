# 某社用簡易残業時間計算機
# 
# 勤務日数、勤務開始時間、終了時間を入力し、
# 休憩時間を考慮した残業時間を算出する。
# 
# *このプログラムにはActive Supportが必須です。
# Active Supportのインストール: 
# gem install activesupport
#
# 25/06/2018
# Masato Miyano

require 'active_support'
require 'active_support/core_ext'

#TODO 通常勤務しか対応してない・・・

class Main
	def initialize
	end

	def self.navigate
		time_info = TimeCalc.new
		print "先週は何日勤務しましたか?: "
		days = gets.to_i
		days.times do |d|
			puts "#{d+1}日目の勤務開始、終了時間を入力してください。"
			print "開始時間(hh:mm): "
			start_time = gets
			print "終了時間(hh:mm): "
			end_time = gets
			time_info.add_time(start_time,end_time)
			puts "#{d+1}日目の残業時間: #{time_info.total_time}"
			puts ""
		end

		puts "¥¥¥"
		puts "------------------------------"
		puts "総残業時間: #{time_info.total_time}"
		puts "------------------------------"
		puts "$$$"
	end	
end	

class TimeCalc
	attr_reader :total_time
	def initialize
		@total_time = 0
	end	

	def add_time(start_time, end_time)
		before = over_worked_time_before_start_time(start_time)
		after = orver_worked_time_after_end_time(end_time)
		@total_time += before + after
	end


	def over_worked_time_before_start_time(start_time)
		before_start_time = ("#{Date.today} 9:00".to_time - "#{Date.today} #{start_time}".to_time) / 3600
		before_start_time < 0 ? 0 : before_start_time
	end	

	def orver_worked_time_after_end_time(end_time)
		after = 0
		#18:00 - 18:30
		after_first_rest = ("#{Date.today} #{end_time}".to_time - "#{Date.today} 18:30".to_time) / 3600
		after = after_first_rest < 0 ? 0 : after_first_rest
		#21:30 - 22:00 
		after -= if worked_after_second_rest?(end_time)
							 # 22時以降勤務していた場合、休憩時間のため30分削減する。
							 0.5
						 else
							 # 22時は超えず21:30 ~ 22:00の間勤務していた場合、
							 # 休憩時間のため削減する。
							 wroked_time_during_second_rest(end_time) > 0 ? wroked_time_during_second_rest(end_time) : 0
						 end
	end		

	def worked_after_second_rest?(end_time)
		(("#{Date.today} #{end_time}".to_time - "#{Date.today} 22:00".to_time) / 3600) > 0
	end	

	def wroked_time_during_second_rest(end_time)
		("#{Date.today} #{end_time}".to_time - "#{Date.today} 21:30".to_time) / 3600
	end	
end

Main.navigate
