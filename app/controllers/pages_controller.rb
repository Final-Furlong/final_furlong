require 'sendgrid-ruby'

class PagesController < ApplicationController
  include SendGrid

  skip_after_action :verify_authorized

  # @route GET / (root)
  def home
  end

  # @route GET /activation_required (activation)
  def activation
  end

  def test_email
    from = Email.new(email: 'no-reply@finalfurlong.org')
    to = Email.new(email: 'equestrianerd@gmail.com')
    subject = 'Sending with SendGrid is Fun'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    respond_to do |format|
      format.html { "ok" }
    end
  end
end

