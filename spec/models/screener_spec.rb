require 'rails_helper'

RSpec.describe Screener, type: :model do
  it { should belong_to :check_in }
  it { should have_many :responses }
  it { should accept_nested_attributes_for(:responses) }

  describe "high_scored?" do
    let(:screener) { create(:screener) }

    it "returns true if at least one response is answered greater than 1" do
      create(:response, screener: screener, answer: 0)
      create(:response, screener: screener, answer: 2)

      expect(screener.high_scored?).to be_truthy
    end

    it "returns false if no response is answered greater than 1" do
      create(:response, screener: screener, answer: 0)
      create(:response, screener: screener, answer: 1)

      expect(screener.high_scored?).to be_falsey
    end
  end

  describe "last_phq?" do
    let(:screener) { create(:screener, phq_level: 2) }

    it "returns false if screener is not the last level PHQ" do
      expect(screener.last_phq?).to be_falsey
    end

    it "returns true if screener is the last level PHQ" do
      screener.update(phq_level: Screener::QUESTIONS.keys.max)

      expect(screener.last_phq?).to be_truthy
    end
  end
end
