class HomeController < ApplicationController
  QUESTIONS_PER_PAGE = 12

  def index
    all_questions = OpinionQuestion.in_display_order.includes(:category, :tags, :fact_questions).to_a
    @discovery = TopicDiscovery.new(all_questions)
    @popular_questions = @discovery.popular
    @controversial_questions = @discovery.controversial
    @categories = Category.order(:name).includes(:opinion_questions)
    @popular_tags = Tag.joins(:opinion_questions)
      .group("tags.id")
      .order(Arel.sql("COUNT(opinion_questions.id) DESC"), :name)
      .limit(12)
    filtered_questions = filter_questions(all_questions)
    @result_count = filtered_questions.length
    @total_pages = [ (@result_count.fdiv(QUESTIONS_PER_PAGE)).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @total_pages)
    @opinion_questions = filtered_questions.slice((@page - 1) * QUESTIONS_PER_PAGE, QUESTIONS_PER_PAGE) || []
    @collective_by_question = @opinion_questions.index_with { |question| CollectiveOpinion.new(question) }
    return unless user_signed_in?

    @user_opinions = current_user.user_opinions.index_by(&:opinion_question_id)
    @progress_by_question = @opinion_questions.index_with do |question|
      OpinionProgress.new(current_user, question)
    end
  end

  private

  def filter_questions(questions)
    query = params[:q].to_s.strip.downcase

    questions.select do |question|
      matches_query = query.blank? || searchable_text(question).include?(query)
      matches_category = params[:category].blank? || question.category&.slug == params[:category]
      matches_tag = params[:tag].blank? || question.tags.any? { |tag| tag.slug == params[:tag] }
      matches_query && matches_category && matches_tag
    end
  end

  def searchable_text(question)
    [
      question.title,
      question.statement,
      question.category&.name,
      question.tags.map(&:name)
    ].flatten.compact.join(" ").downcase
  end
end
