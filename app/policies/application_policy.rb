# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :record

  def initialize(record = nil)
    @record = record
  end

  class Scope
    attr_reader :scope

    def initialize(scope)
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
