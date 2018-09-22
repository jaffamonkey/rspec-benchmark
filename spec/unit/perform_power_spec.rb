# frozen_string_literal: true

RSpec.describe 'RSpec::Benchmark::ComplexityMatcher', '#perform_power' do
  # exponential
  def fibonacci(n)
    n < 2 ? n : fibonacci(n - 1) + fibonacci(n - 2)
  end

  def prefix_avg(numbers)
    result = []
    numbers.each_with_index do |i, num|
      sum = 0.0
      numbers[0..i].each do |a|
        sum += a
      end
      result[i] = sum / i
    end
    result
  end

  it "propagates error inside expectation" do
    expect {
      expect { raise 'boom' }.to perform_power
    }.to raise_error(StandardError, /boom/)
  end

  context "expect { ... }.to perfom_power" do
    it "passes if the block performs power" do
      range = (1..10_000).step(100).to_a
      numbers = range.map { |n| Array.new(n) { rand(n) } }.each

      expect { |n|
        prefix_avg(numbers.next)
      }.to perform_power.within(range[0], range[-1])
    end

    it "fails if the block doesn't perform power" do
      expect {
        expect { |n|
          fibonacci(n)
        }.to perform_power.within(1, 25)
      }.to raise_error("expected block to perform power, but performed exponential")
    end
  end

  context "expect { ... }.not_to perfom_power" do
    it "passes if the block does not perform power" do
      expect { |n|
        fibonacci(n)
      }.not_to perform_power.within(1, 25)
    end

    it "fails if the block doesn't perform power" do
      range = (1..10_000).step(100).to_a
      numbers = range.map { |n| Array.new(n) { rand(n) } }.each

      expect {
        expect { |n|
          prefix_avg(numbers.next)
        }.not_to perform_power.within(range[0], range[-1])
      }.to raise_error("expected block not to perform power, but performed power")
    end
  end
end