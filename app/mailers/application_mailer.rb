# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: MY_EMAIL
  layout 'mailer'
end
