class Response < ApplicationRecord
  belongs_to :screener

  validates_presence_of :question
  validate do |response|
    if response.answer.blank?
      screener.errors.add(:base, "You need to answer each question.")
    end
  end

  scope :high_scored, -> { where("responses.answer > ?", 1) }
end
