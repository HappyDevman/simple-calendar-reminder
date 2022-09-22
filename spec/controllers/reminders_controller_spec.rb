# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemindersController, type: :controller do
  before do
    allow(ReminderPolicy).to receive(:new).and_return(reminder_policy)
  end

  let(:reminder) { create(:reminder) }

  let(:reminder_policy) do
    instance_double(ReminderPolicy,
                    index?: true,
                    new?: true,
                    create?: true,
                    edit?: true,
                    update?: true,
                    destroy?: true)
  end

  let(:new_params) do
    {
      reminder: { message: nil, datetime: nil, color: nil }
    }
  end

  let(:valid_params) do
    {
      reminder: { message: Faker::Lorem.characters(number: 10), datetime: Time.zone.now + 3.days, color: '#000000' }
    }
  end

  let(:invalid_params) do
    {
      reminder: { message: Faker::Lorem.characters(number: 31), datetime: Time.zone.now - 3.days, color: '#000000' }
    }
  end

  describe 'GET #index' do
    context 'with valid' do
      before do
        get :index
      end

      it { is_expected.to respond_with(:ok) }
      it { is_expected.to render_template(:index) }
    end
  end

  describe 'GET #new' do
    context 'with valid' do
      before do
        get :new, params: invalid_params
      end

      it { is_expected.to respond_with(:ok) }
      it { is_expected.to render_template(:new) }
    end
  end

  describe 'POST #create' do
    context 'with valid' do
      before do
        post :create, params: valid_params
      end

      it { is_expected.to respond_with(:found) }
      it { is_expected.to redirect_to(reminders_path) }
    end

    context 'with invalid' do
      before do
        post :create, params: invalid_params
      end

      it { is_expected.to respond_with(:ok) }
      it { is_expected.to render_template(:new) }
    end
  end

  describe 'GET #edit' do
    context 'with valid' do
      before do
        get :edit, params: { id: reminder.id }
      end

      it { is_expected.to respond_with(:ok) }
      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'PUT #update' do
    context 'with valid' do
      before do
        put :update, params: { id: reminder.id, reminder: valid_params }
      end

      it { is_expected.to respond_with(:found) }
      it { is_expected.to redirect_to(reminders_path) }
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid' do
      before do
        delete :destroy, params: { id: reminder.id }
      end

      it { is_expected.to respond_with(:found) }
      it { is_expected.to redirect_to(reminders_path) }
    end
  end
end
