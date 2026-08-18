class PageSocialCardsController < ApplicationController
  skip_before_action :require_current_privacy_consent

  CARDS = {
    "proposals" => {
      "informed_opinion" => {
        title: "Propose a question",
        subtitle: "Help shape what Informed Opinion examines next"
      },
      "whats_your_view" => {
        title: "Suggest a question",
        subtitle: "What should we explore next?"
      }
    }
  }.freeze

  def show
    card = CARDS.dig(params[:page_key], params[:site_key])
    raise ActiveRecord::RecordNotFound unless card

    image_data = SocialCardRenderer.new(
      **card,
      site_key: params[:site_key],
      decorative: false,
      brand_rule: false
    ).render
    expires_in 1.year, public: true, immutable: true
    send_data image_data, type: "image/png", disposition: "inline"
  end
end
