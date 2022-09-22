# frozen_string_literal: true

class ReminderPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    true
  end

  def update?
    edit?
  end

  def destroy?
    true
  end
end
