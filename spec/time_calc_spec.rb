require 'spec_helper'
require './time_calc'

describe "TimeCalc" do
  let(:time_calc){
    TimeCalc.new
  }
  describe "#add_time" do
    context "when worked regular time (9:00 ~ 18:00)" do
      it "return zero" do
        expected = 0
        actual = time_calc.add_time('9:00','18:00')
        expect(actual).to eq(expected)
      end
    end
    context "when worked before and after regular time(9:00 ~ 18:00)" do
      it "return overworked time" do
        expected = 3.25
        actual = time_calc.add_time('8:15','21:00')
        expect(actual).to eq(expected)
      end
    end
    context "when started to work earlier than start time(9:00)" do
      it "return overworked time" do
        expected = 0.75
        actual = time_calc.add_time('8:15', '18:00')
        expect(actual).to eq(expected)
      end
    end
    context "when worked after end time(18:00)" do
      context "worked till 18:15(during rest time)" do
        it "return zero" do
          expected = 0
          actual = time_calc.add_time('9:00','18:15')
          expect(actual).to eq(expected)
        end
      end
      context "worked till 18:30(end time of break)" do
        it "return zero" do
          expected = 0
          actual = time_calc.add_time('9:00','18:30')
          expect(actual).to eq(expected)
        end
      end
      context "worked till 20:00" do
        it "return overworked time" do
          expected = 1.5
          actual = time_calc.add_time('9:00','20:00')
          expect(actual).to eq(expected)
        end
      end
    end
    context "when worked after second break(21:30)" do
      context "worked till 21:30" do
        it "return overworked time except 1st break time" do
          expected = 3.0
          actual = time_calc.add_time('9:00','21:30')
          expect(actual).to eq(expected)
        end
      end
      context "worked till 21:45(during 2nd rest time)" do
        it "return overworked time except 1st and 2nd break time" do
          expected = 3.0
          actual = time_calc.add_time('9:00','21:45')
          expect(actual).to eq(expected)
        end
      end
      context "worked till 22:00(end of 2nd rest time)" do
        it "return overworked time except 1st and 2nd break time" do
          expected = 3.0
          actual = time_calc.add_time('9:00','22:00')
          expect(actual).to eq(expected)
        end
      end
      context "worked after 22:00(end of 2nd rest time)" do
        it "return overworked time except 1st and 2nd break time" do
          expected = 3.5
          actual = time_calc.add_time('9:00','22:30')
          expect(actual).to eq(expected)
        end
      end
    end
  end
end