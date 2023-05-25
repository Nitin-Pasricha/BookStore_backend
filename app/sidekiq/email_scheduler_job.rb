class EmailSchedulerJob
  include Sidekiq::Job

  def perform(user)
    puts "email-sent: #{user}"
    NotifierMailer.with(user:user).order_confirmation_email.deliver_now
  end
end
