class ApplicationMailer < ActionMailer::Base
  default from: "mails_send"
  layout "mailer"
end
