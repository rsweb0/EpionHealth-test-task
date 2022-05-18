class Screener < ApplicationRecord
  # We are storing the whole question string in database.
  # Instead we could also use enum but in future if we want to change the sequence
  # of questions or any question itself then enum will cause issue for existing data.

  # format: { phq_level => [questions] }
  QUESTIONS = {
    1 => [
      'Little interest or pleasure in doing things?',
      'Feeling down, depressed or hopeless?',
    ],
    2 => [
      'Trouble falling or staying asleep, or sleeping too much?',
      'Feeling tired or having little energy?'
    ],
    3 => [
      'Poor appetite or overeating?',
      'Feeling bad about yourself or that you are a failure or have let yourself
       or your family down?'
    ],
    4 => [
      'Trouble concentrating on things, such as reading the newspaper 
       or watching television?',
       'Thoughts that you would be better off dead, or of hurting yourself?'
    ]
  }

  ANSWER_OPTIONS = [
    [0, 'Not at all'],
    [1, 'Several days'],
    [2, 'More than half the days'],
    [3, 'Nearly every day']
  ]

  belongs_to :check_in
  has_many :responses, dependent: :destroy

  accepts_nested_attributes_for :responses, allow_destroy: true

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

  validates :phq_level, presence: true, uniqueness: { scope: :check_in_id }

  def high_scored?
    responses.high_scored.present?
  end

  def last_phq?
    QUESTIONS.keys.max == phq_level
  end
end
