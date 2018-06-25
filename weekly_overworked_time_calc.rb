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

#TODO 通常勤務しか対応してない・・・

class Main
	require './time_calc'

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

Main.navigate
