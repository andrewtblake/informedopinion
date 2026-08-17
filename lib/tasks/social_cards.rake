namespace :social_cards do
  desc "Generate both social-card variants for every opinion question"
  task generate: :environment do
    OpinionQuestion.find_each do |question|
      SocialCard::SITE_KEYS.each { SocialCardGenerator.generate!(question, _1) }
      puts "Generated social cards for #{question.slug}"
    end
  end
end
