class HomeController < ApplicationController
  QUESTIONS_PER_PAGE = 12
  SORT_OPTIONS = {
    "featured" => "Featured",
    "popular" => "Most popular",
    "controversial" => "Most controversial",
    "title" => "Title A–Z"
  }.freeze

  def index
    all_questions = OpinionQuestion.live.in_display_order.includes(:category, :tags, :fact_questions).to_a
    @discovery = TopicDiscovery.new(all_questions)
    @popular_questions = @discovery.popular
    @controversial_questions = @discovery.controversial
    @categories = Category.order(:name).includes(:live_opinion_questions)
    @popular_tags = Tag.joins(:opinion_questions)
      .merge(OpinionQuestion.live)
      .group("tags.id")
      .order(Arel.sql("COUNT(opinion_questions.id) DESC"), :name)
      .limit(12)
    @selected_tag = Tag.find_by(slug: params[:tag]) if params[:tag].present?
    filtered_questions = filter_questions(all_questions)
    @sort_options = SORT_OPTIONS
    @sort = SORT_OPTIONS.key?(params[:sort]) ? params[:sort] : "featured"
    filtered_questions = order_questions(filtered_questions)
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

  def order_questions(questions)
    case @sort
    when "popular"
      TopicDiscovery.new(questions).popular(limit: questions.length)
    when "controversial"
      discovery = TopicDiscovery.new(questions)
      ranked = discovery.controversial(limit: questions.length)
      ranked + (questions - ranked)
    when "title"
      questions.sort_by { [ _1.title.downcase, _1.id ] }
    else
      questions.sort_by { [ _1.display_order, _1.id ] }
    end
  end
end
