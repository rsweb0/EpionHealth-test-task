class CheckIn < ApplicationRecord
  belongs_to :patient
  has_many :screeners

  def screeners_by_phq_level
    screeners.order('phq_level asc')
  end

  def next_phq_level
    (screeners_by_phq_level.last&.phq_level || 0) + 1
  end

  def completed?
    last_screener = screeners_by_phq_level.last

    return false unless last_screener

    last_screener.last_phq? || !last_screener.high_scored?
  end
end
