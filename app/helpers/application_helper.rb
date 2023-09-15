# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = nil)
    base_title = APP_NAME

    # .reject(&:blank?) : strike out 'nil' and ''
    [page_title, base_title].reject(&:blank?).join(' | ')
  end
end
