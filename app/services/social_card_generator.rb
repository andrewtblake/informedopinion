class SocialCardGenerator
  def self.generate!(opinion_question, site_key)
    site_key = site_key.to_s
    image_data = SocialCardRenderer.new(title: opinion_question.title, site_key: site_key).render
    fingerprint = SocialCardRenderer.fingerprint(opinion_question.title, site_key)
    card = SocialCard.find_or_initialize_by(opinion_question: opinion_question, site_key: site_key)
    card.update!(
      image_data: image_data,
      byte_size: image_data.bytesize,
      content_type: "image/png",
      content_fingerprint: fingerprint,
      template_version: SocialCardRenderer::TEMPLATE_VERSION,
      generated_at: Time.current
    )
    card
  end
end
