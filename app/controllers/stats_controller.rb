class StatsController < ApplicationController
  before_action :authenticate_user!

  SORT_OPTIONS = {
    "recent" => "Recently revised",
    "title" => "Title A–Z",
    "weight" => "Highest opinion weight",
    "progress" => "Most questions answered"
  }.freeze
  PER_PAGE = 12

  def show
    @sort_options = SORT_OPTIONS
    @sort = SORT_OPTIONS.key?(params[:sort]) ? params[:sort] : "recent"
    @query = params[:q].to_s.strip

    opinions = current_user.user_opinions
      .includes(opinion_question: [ :category, :tags, :fact_questions ])
      .to_a
    fact_question_ids = opinions.flat_map { _1.opinion_question.fact_questions.map(&:id) }
    responses_by_question = current_user.fact_responses
      .includes(:fact_question)
      .where(fact_question_id: fact_question_ids)
      .group_by { _1.fact_question.opinion_question_id }

    records = opinions.map do |opinion|
      question = opinion.opinion_question
      progress = OpinionProgress.new(
        current_user,
        question,
        responses: responses_by_question.fetch(question.id, [])
      )
      { opinion: opinion, question: question, progress: progress }
    end

    records.select! { |record| searchable_text(record[:question]).include?(@query.downcase) } if @query.present?
    records.sort_by! { |record| sort_key(record) }

    @result_count = records.length
    @total_pages = [ (@result_count.fdiv(PER_PAGE)).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @total_pages)
    @opinion_records = records.slice((@page - 1) * PER_PAGE, PER_PAGE) || []
  end

  private

  def searchable_text(question)
    [
      question.title,
      question.statement,
      question.category&.name,
      *question.tags.map(&:name)
    ].compact.join(" ").downcase
  end

  def sort_key(record)
    case @sort
    when "title"
      [ record[:question].title.downcase, record[:question].id ]
    when "weight"
      [ -record[:progress].weight, record[:question].title.downcase ]
    when "progress"
      [ -record[:progress].answered, record[:question].title.downcase ]
    else
      [ -record[:opinion].updated_at.to_f, record[:question].title.downcase ]
    end
  end
end
