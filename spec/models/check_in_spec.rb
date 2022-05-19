require 'rails_helper'

RSpec.describe CheckIn, type: :model do
  let(:check_in) { create(:check_in) }

  it { should belong_to :patient }
  it { should have_many :screeners }

  describe "screeners_by_phq_level" do
    before do
      3.times { |i| create(:screener, check_in: check_in, phq_level: i + 1) } 
    end

    it "returns the screeners ordered by phq_level" do
      ordered_screeners = check_in.screeners.order('phq_level asc')

      expect(check_in.screeners_by_phq_level).to eq(ordered_screeners)
    end
  end

  describe "next_phq_level" do
    before do
      2.times { |i| create(:screener, check_in: check_in, phq_level: i + 1) }
    end

    it "returns phq_level for next screener" do
      expect(check_in.next_phq_level).to eq(3)
    end
  end

  describe "completed?" do
    it "returns true if all PHQ are completed" do
      4.times { |i| create(:screener, check_in: check_in, phq_level: i + 1) }

      expect(check_in.completed?).to be_truthy
    end

    it "returns true if the last PHQ does not have high score" do
      screener = create(:screener, check_in: check_in, phq_level: 2)
      create(:response, screener: screener, answer: 1)
      create(:response, screener: screener, answer: 0)

      expect(check_in.completed?).to be_truthy
    end

    it "returns if the last screener has high score" do
      screener = create(:screener, check_in: check_in, phq_level: 2)
      create(:response, screener: screener, answer: 3)
      create(:response, screener: screener, answer: 0)

      expect(check_in.completed?).to be_falsey
    end
  end
end
