class Response < ApplicationRecord
  belongs_to :screener

  validates_presence_of :question

  validates :answer, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 3,
    message: "not a valid value",
    allow_blank: true
  }

  validate do |response|
    if response.answer.blank?
      errors.add(:base, "You need to answer each question.")
    end
  end

  scope :high_scored, -> { where("responses.answer > ?", 1) }
end
