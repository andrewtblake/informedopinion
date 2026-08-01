namespace :moderator_api_tokens do
  desc "Issue a moderator API token (EMAIL=... NAME=...) and print it once"
  task issue: :environment do
    user = User.find_by!(email: ENV.fetch("EMAIL").downcase)
    abort "That account is not a moderator." unless user.moderator?

    token, plaintext = ModeratorApiToken.issue!(user: user, name: ENV.fetch("NAME", "Codex MCP"))
    ApiAuditEvent.create!(actor: user, moderator_api_token: token, action: "moderator_api_token.issue",
      resource_type: token.class.name, resource_id: token.id, change_data: { "name" => token.name })
    puts "Created token #{token.name.inspect} (#{token.token_prefix}…)."
    puts plaintext
    puts "Store it securely: it cannot be displayed again. Revoke it by setting revoked_at on token ##{token.id}."
  end

  desc "Revoke a moderator API token (ID=...)"
  task revoke: :environment do
    token = ModeratorApiToken.find(ENV.fetch("ID"))
    token.revoke!
    ApiAuditEvent.create!(actor: token.user, moderator_api_token: token, action: "moderator_api_token.revoke",
      resource_type: token.class.name, resource_id: token.id)
    puts "Revoked token ##{token.id}."
  end
end
