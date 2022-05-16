class Screener < ApplicationRecord
  # We are storing the whole question string in database.
  # Instead we could also use enum but in future if we want to change the sequence
  # of questions or any question itself then enum will cause issue for existing data.
  QUESTIONS = [
    'Little interest or pleasure in doing things?',
    'Feeling down, depressed or hopeless?',
  ]

  ANSWER_OPTIONS = [
    [0, 'Not at all'],
    [1, 'Several days'],
    [2, 'More than half the days'],
    [3, 'Nearly every day']
  ]

  belongs_to :check_in
  has_many :responses, dependent: :destroy

  accepts_nested_attributes_for :responses

  # This logic is added to show more user friendly error messages
  validate do |screener|
    if screener.responses.present?
      screener.errors.clear
      screener.responses.each do |response|
        next if response.valid?
        response.errors.full_messages.each do |message|
          errors.add(:base, message)
        end
      end
    end
  end

  def high_scored?
    responses.high_scored.present?
  end
end
