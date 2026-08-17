class SocialCardsController < ApplicationController
  skip_before_action :require_current_privacy_consent

  def show
    question = OpinionQuestion.live.find_by!(slug: params[:slug])
    site_key = params[:site_key].to_s
    raise ActiveRecord::RecordNotFound unless site_key.in?(SocialCard::SITE_KEYS)

    expected = SocialCardRenderer.fingerprint(question.title, site_key)
    raise ActiveRecord::RecordNotFound unless ActiveSupport::SecurityUtils.secure_compare(params[:fingerprint], expected)

    card = SocialCard.fetch_or_generate!(question, site_key)
    expires_in 1.year, public: true, immutable: true
    send_data card.image_data, type: card.content_type, disposition: "inline"
  end
end
