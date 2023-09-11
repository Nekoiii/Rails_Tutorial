class ApplicationMailer < ActionMailer::Base
  default from: MY_EMAIL
  layout "mailer"
end
