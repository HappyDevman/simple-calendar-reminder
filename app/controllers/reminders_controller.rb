# frozen_string_literal: true

class RemindersController < ApplicationController
  def index
    authorize_action
    reminders = Reminder.all
    reminders_by_date = reminders.group_by(&:date)
    render :index, locals: {
      reminders: reminders,
      reminders_by_date: reminders_by_date,
      date: params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    }
  end

  def new
    authorize_action
    reminder = Reminder.new
    render :new, locals: { reminder: reminder }
  end

  def create
    authorize_action
    reminder = Reminder.create(reminder_params)
    if reminder.save
      redirect_to reminders_path
    else
      render :new, locals: { reminder: reminder }
    end
  end

  def edit
    authorize_action(reminder)
    render :edit, locals: { reminder: reminder }
  end

  def update
    authorize_action(reminder)
    if reminder.update(reminder_params)
      redirect_to reminders_path
    else
      render :edit, locals: { reminder: reminder }
    end
  end

  def destroy
    authorize_action(reminder)
    reminder.destroy!
    redirect_to reminders_path
  end

  private

  def reminder
    @reminder ||= Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:message, :datetime, :color)
  end

  def policy_class
    ReminderPolicy
  end

  def authorize_action(record = Reminder)
    authorize(record, "#{action_name}?", policy_class: policy_class)
  end
end
