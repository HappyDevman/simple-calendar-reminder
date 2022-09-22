# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authorize(record, action_name, policy_class); end
end
