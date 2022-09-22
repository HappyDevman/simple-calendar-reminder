# frozen_string_literal: true

module CalendarHelper
  HEADER = %w[Sun Mon Tue Wed Thu Fri Sat].freeze
  START_DAY = :sunday
  NUMBER_DAY_OF_WEEK = 7

  def calendar(date: Time.zone.today, reminders: [])
    @date = date
    @reminders = reminders
    tag.table(class: 'calendar') do
      header + week_rows
    end
  end

  def header
    tag.thead do
      HEADER.map { |day| tag.th(day) }.join.html_safe
    end
  end

  def week_rows
    weeks.map do |week|
      tag.tr do
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end.join.html_safe
  end

  def day_cell(day)
    tag.td(class: day_classes(day)) do
      concat(tag.span(day.strftime('%e')))
      concat(reminders_by_date(day))
    end
  end

  def day_classes(day)
    classes = []
    classes << 'today' if day == Time.zone.today
    classes << 'sunday' if day.wday.zero?
    classes << 'notmonth' if day.month != @date.month
    classes.empty? ? nil : classes.join(' ')
  end

  def weeks
    first = @date.beginning_of_month.beginning_of_week(START_DAY)
    last = @date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(NUMBER_DAY_OF_WEEK)
  end

  def reminders_by_date(day)
    return if @reminders[day].blank?

    tag.ul(class: 'reminder-list') do
      @reminders[day].map do |reminder|
        tag.li(class: 'reminder-item') do
          link_to reminder.summary, edit_reminder_path(reminder), style: "background: #{reminder.color}"
        end
      end.join.html_safe
    end
  end
end
