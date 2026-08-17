require "test_helper"

class GenerateSocialCardsJobTest < ActiveJob::TestCase
  setup do
    @category = Category.create!(name: "Card category", slug: "card-category")
    @question = OpinionQuestion.create!(
      category: @category,
      title: "A social question",
      statement: "This is a proposition.",
      slug: "a-social-question",
      display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS
    )
    clear_enqueued_jobs
  end

  test "generates and stores both branded variants" do
    GenerateSocialCardsJob.perform_now(@question.id)

    assert_equal %w[informed_opinion whats_your_view], @question.social_cards.order(:site_key).pluck(:site_key)
    assert @question.social_cards.all? { _1.image_data.start_with?("\x89PNG".b) }
    assert @question.social_cards.all? { _1.byte_size == _1.image_data.bytesize }
  end

  test "a title change schedules regeneration" do
    assert_enqueued_with(job: GenerateSocialCardsJob, args: [ @question.id ]) do
      @question.update!(title: "A revised social question")
    end
  end

  test "regeneration replaces rather than accumulating variants" do
    GenerateSocialCardsJob.perform_now(@question.id)
    old_fingerprints = @question.social_cards.pluck(:content_fingerprint)
    @question.update!(title: "A revised social question")

    GenerateSocialCardsJob.perform_now(@question.id)

    assert_equal 2, @question.social_cards.count
    assert_empty old_fingerprints & @question.social_cards.reload.pluck(:content_fingerprint)
  end
end
