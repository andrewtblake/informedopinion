namespace :email do
  desc "Send a production email-delivery test (EMAIL=recipient@example.com)"
  task send_test: :environment do
    recipient = ENV["EMAIL"].to_s.strip
    abort "Set EMAIL to the address that should receive the test." if recipient.blank?

    SystemMailer.with(to: recipient).delivery_test.deliver_now

    puts "Delivery accepted for #{recipient}. Check the inbox and spam folder."
  end
end
