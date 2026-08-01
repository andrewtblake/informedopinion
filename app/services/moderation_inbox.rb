class ModerationInbox
  Item = Data.define(:section, :key, :version)

  SECTION_IDS = %w[
    question-preparation
    fact-question-reports
    opinion-question-proposals
    fact-question-proposals
    opinion-question-reactions
  ].freeze

  def initialize(moderator)
    @moderator = moderator
  end

  def items
    @items ||= draft_items + flag_items + opinion_proposal_items + fact_proposal_items + reaction_items
  end

  def unseen_items
    views = moderator.moderation_item_views.where(item_key: items.map(&:key)).index_by(&:item_key)
    items.select do |item|
      view = views[item.key]
      view.nil? || view.seen_version_at < item.version
    end
  end

  def sections
    unseen_items.group_by(&:section).transform_values do |section_items|
      {
        count: section_items.length,
        items: section_items.map { { key: _1.key, version: _1.version.iso8601(6) } }
      }
    end.tap do |result|
      SECTION_IDS.each { |section| result[section] ||= { count: 0, items: [] } }
    end
  end

  def version_for(key)
    items.find { _1.key == key }&.version
  end

  def mark_displayed!(submitted_items)
    current = items.index_by(&:key)
    displayed_at = Time.current

    Array(submitted_items).each do |submitted|
      item = current[submitted[:key].to_s]
      submitted_version = Time.iso8601(submitted[:version].to_s)
      next unless item && item.version <= submitted_version

      view = moderator.moderation_item_views.find_or_initialize_by(item_key: item.key)
      next if view.persisted? && view.seen_version_at >= item.version

      view.update!(seen_version_at: item.version, displayed_at: displayed_at)
    rescue ArgumentError
      next
    end
  end

  private

  attr_reader :moderator

  def draft_items
    OpinionQuestion.where(live: false).map { item("question-preparation", "draft", _1) }
  end

  def flag_items
    FactQuestionFlag.pending.map { item("fact-question-reports", "fact-report", _1) }
  end

  def opinion_proposal_items
    OpinionQuestionProposal.pending.map { item("opinion-question-proposals", "opinion-proposal", _1) }
  end

  def fact_proposal_items
    FactQuestionProposal.pending.map { item("fact-question-proposals", "fact-proposal", _1) }
  end

  def reaction_items
    OpinionQuestion.joins(:opinion_question_reactions).distinct.filter_map do |question|
      version = question.opinion_question_reactions.maximum(:updated_at)
      Item.new(section: "opinion-question-reactions", key: "opinion-reactions:#{question.id}", version: version) if version
    end
  end

  def item(section, prefix, record)
    Item.new(section: section, key: "#{prefix}:#{record.id}", version: record.updated_at)
  end
end
