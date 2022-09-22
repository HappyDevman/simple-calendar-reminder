# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  let(:reminder) { create(:reminder) }

  describe 'Table structure' do
    it { is_expected.to have_db_column(:datetime).of_type(:datetime) }
    it { is_expected.to have_db_column(:message).of_type(:string) }
    it { is_expected.to have_db_column(:color).of_type(:string) }
  end

  describe 'Model validations' do
    it { is_expected.to validate_presence_of(:datetime) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_length_of(:message).is_at_most(30) }
  end

  describe '#overdue_datetime?' do
    it 'successes when datetime is in future date' do
      reminder.overdue_datetime?
      expect(reminder.errors).to be_blank
    end

    it 'fails when datetime is in past date' do
      reminder.update(datetime: Time.zone.now)
      reminder.overdue_datetime?
      expect(reminder.errors[:datetime]).to be_present
    end
  end

  describe '#date' do
    it { expect(reminder.date).to eq(reminder.datetime.to_date) }
  end

  describe '#summary' do
    it 'returns full message when message is less than 10' do
      reminder.update(message: Faker::Lorem.characters(number: 10))
      expect(reminder.summary).to eq(reminder.message)
    end

    it 'returns wrapped message when message is greater than 10' do
      expect(reminder.summary.length).to eq(13)   # contains 10 letters of the message and ...
    end
  end
end
