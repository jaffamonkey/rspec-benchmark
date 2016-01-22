# encoding: utf-8

RSpec.describe 'RSpec::Benchmark::TimingMatcher', '#perform_under' do

  context "expect { ... }.to perfom_under(...).and_sample" do
    it "passes if the block performs under threshold" do
      expect {
        'x' * 1024 * 10
      }.to perform_under(0.006).sec.and_sample(10)
    end

    it "fails if the block performs above threshold" do
      expect {
        expect {
          'x' * 1024 * 1024 * 100
        }.to perform_under(0.0001).and_sample(5)
      }.to raise_error(/expected block to perform under 0\.0001 threshold, but performed above \d+\.\d+ \(± \d+\.\d+\) secs/)
    end
  end

  context "expect { ... }.not_to perform_under(...).and_sample" do
    it "passes if the block does not perform under threshold" do
      expect {
        'x' * 1024 * 1024 * 10
      }.to_not perform_under(0.001).and_sample(2)
    end

    it "fails if the block perfoms under threshold" do
      expect {
        expect {
          'x' * 1024 * 1024 * 10
        }.to_not perform_under(0.1).and_sample(2)
      }.to raise_error(/expected block to not perform under 0\.1 threshold, but performed \d+\.\d+ \(± \d+\.\d+\) secs under/)
    end
  end
end