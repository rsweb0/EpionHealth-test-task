require 'rails_helper'

RSpec.describe Response, type: :model do
  it { should belong_to :screener }
  it { should validate_presence_of :question }

  it do 
    should validate_numericality_of(:answer)
      .only_integer
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(3)
      .with_message('not a valid value')
  end
  
  it "sets custom validation error is answer is blank" do
    response = described_class.new

    expect(response).to_not be_valid
    expect(response.errors[:base]).to include("You need to answer each question.")
  end

  describe "high_scored" do
    let!(:res_one) { create(:response, answer: 0) }
    let!(:res_two) { create(:response, answer: 1) }
    let!(:res_three) { create(:response, answer: 2) }
    let!(:res_four) { create(:response, answer: 3) }

    it "returns the records with answer greater than 1" do
      results = described_class.high_scored

      expect(results).to_not include(res_one)
      expect(results).to_not include(res_two)
      expect(results).to include(res_three)
      expect(results).to include(res_four)
    end
  end
end
