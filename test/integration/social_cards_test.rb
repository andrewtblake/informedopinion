require "test_helper"

class SocialCardsTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Sharing", slug: "sharing")
    @question = OpinionQuestion.create!(
      category: @category,
      title: "Has evidence changed minds?",
      statement: "Evidence should be considered before reaching a view.",
      slug: "has-evidence-changed-minds",
      live: true,
      display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS
    )
  end

  test "topic metadata selects the Informed Opinion card on the primary host" do
    host! "informedopinion.localhost"
    get opinion_question_path(@question)

    assert_response :success
    fingerprint = SocialCardRenderer.fingerprint(@question.title, "informed_opinion")
    expected = social_card_url(slug: @question.slug, site_key: "informed_opinion", fingerprint: fingerprint,
      host: "informedopinion.localhost")
    assert_select "meta[property='og:title'][content='#{@question.title} — Informed Opinion']"
    assert_select "meta[property='og:description'][content='#{@question.statement}']"
    assert_select "meta[property='og:image'][content='#{expected}']"
  end

  test "topic metadata selects the separate What's Your View card on its host" do
    host! "whatsyourview.localhost"
    get opinion_question_path(@question)

    assert_response :success
    fingerprint = SocialCardRenderer.fingerprint(@question.title, "whats_your_view")
    expected = social_card_url(slug: @question.slug, site_key: "whats_your_view", fingerprint: fingerprint,
      host: "whatsyourview.localhost")
    assert_select "meta[property='og:title'][content=?]", "#{@question.title} — What's Your View?"
    assert_select "meta[property='og:image'][content='#{expected}']"
  end

  test "a fingerprinted card endpoint lazily creates and serves a PNG" do
    fingerprint = SocialCardRenderer.fingerprint(@question.title, "informed_opinion")
    get social_card_path(slug: @question.slug, site_key: "informed_opinion", fingerprint: fingerprint)

    assert_response :success
    assert_equal "image/png", response.media_type
    assert response.body.b.start_with?("\x89PNG".b)
    assert_match(/max-age=#{1.year.to_i}/, response.headers.fetch("cache-control"))
    assert_equal 1, @question.social_cards.where(site_key: "informed_opinion").count
  end

  test "a stale fingerprint is not served after the title changes" do
    stale = SocialCardRenderer.fingerprint(@question.title, "informed_opinion")
    @question.update!(title: "A different title")

    get social_card_path(slug: @question.slug, site_key: "informed_opinion", fingerprint: stale)

    assert_response :not_found
  end
end
