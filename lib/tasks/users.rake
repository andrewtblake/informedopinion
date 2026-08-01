namespace :users do
  desc "Promote an existing verified account to moderator (EMAIL=user@example.com)"
  task promote_moderator: :environment do
    email = ENV["EMAIL"].to_s.strip.downcase
    abort "Set EMAIL to the registered account to promote." if email.blank?

    user = User.find_by(email: email)
    abort "No registered account exists for #{email}. Sign up and verify the address first." unless user

    if user.moderator?
      puts "#{email} is already a moderator."
    else
      user.moderator!
      puts "Promoted #{email} to moderator."
    end
  end
end
