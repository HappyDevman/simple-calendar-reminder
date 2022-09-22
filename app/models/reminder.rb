# frozen_string_literal: true

class Reminder < ApplicationRecord
  MESSAGE_SUMMARY_LIMIT = 10

  validates :message, presence: true, length: { maximum: 30 }
  validates :datetime, presence: true
  validate  :overdue_datetime?

  def overdue_datetime?
    errors.add(:datetime, "can't be in the past.") if datetime.present? && (datetime < Time.zone.now)
  end

  def date
    datetime.try(:to_date)
  end

  def summary
    return '' if message.blank?

    if message.size > MESSAGE_SUMMARY_LIMIT
      "#{message[0...MESSAGE_SUMMARY_LIMIT]}..."
    else
      message
    end
  end
end
