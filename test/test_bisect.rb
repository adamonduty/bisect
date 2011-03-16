require 'helper'
require 'bisect'

class TestBisect < Test::Unit::TestCase

  context "when bisecting an Array" do
    setup do 
      @odd_array = [1,3,5,7,9,11]
      @even_array = [2,4,6,8,10]
      @mixed_array = [1,3,5,7,8,10,12,14]
      @single_element_array = [1]
    end

    should "raise BisectionError if no block was given" do
      assert_raise(Array::BisectionError) { @mixed_array.bisect }
    end

    context "in normal mode" do
      should "find no even number failure in fully even array" do
        result = @even_array.bisect { |a| a.even? }
        assert_equal nil, result
      end

      should "find odd number failure as first in fully even array" do
        result = @even_array.bisect { |a| a.odd? }
        assert_equal 2, result
      end

      should "find first even number in mixed array" do
        result = @mixed_array.bisect { |a| a.odd? }
        assert_equal 8, result
      end

      should "find first odd number in mixed array" do
        result = @mixed_array.bisect { |a| a.even? }
        assert_equal 1, result
      end

      should "find no failure for odd number in single element array" do
        result = @single_element_array.bisect { |a| a.odd? }
        assert_equal nil, result
      end

      should "find first failure for even number in single element array" do
        result = @single_element_array.bisect { |a| a.even? }
        assert_equal 1, result
      end
    end

    context "in change detection mode" do
      should "find no change in fully even array testing even?" do
        result = @even_array.bisect(:mode => :change) { |a| a.even? }
        assert_equal nil, result
      end

      should "find no change in fully even array testing odd" do
        result = @even_array.bisect(:mode => :change) { |a| a.odd? }
        assert_equal nil, result
      end

      should "find first even number in mixed array testing even" do
        result = @mixed_array.bisect(:mode => :change) { |a| a.even? }
        assert_equal 8, result
      end

      should "find first even number in mixed array testing odd" do
        result = @mixed_array.bisect(:mode => :change) { |a| a.odd? }
        assert_equal 8, result
      end

      should "never find failure in single element array testing odd" do
        result = @single_element_array.bisect(:mode => :change) { |a| a.odd? }
        assert_equal nil, result
      end

      should "never find failure in single element array testing even" do
        result = @single_element_array.bisect(:mode => :change) { |a| a.even? }
        assert_equal nil, result
      end
    end
  end
  
  context "when bisecting a Time" do
    setup do 
      @start_time = Time.parse("2011-01-01 12:00 EST")
      @end_time = Time.parse("2011-03-15 12:00 EDT")
      @daylight_change = Time.parse("2011-03-13 03:00 EDT")
    end

    context "in change mode" do
      should "find daylight savings" do
        result = @start_time.bisect(@end_time, :mode => :change) { |t| Time.at(t).dst? }
        assert_equal @daylight_change, result
      end
    end

  end
end
