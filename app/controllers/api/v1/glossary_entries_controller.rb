class Api::V1::GlossaryEntriesController < Api::V1::BaseController
  rescue_from ActiveRecord::RecordNotUnique, with: :duplicate_term

  def index
    entries = GlossaryEntry.order(:term)
    if params[:q].present?
      query = "%#{GlossaryEntry.sanitize_sql_like(params[:q])}%"
      entries = entries.where("term LIKE :query OR definition LIKE :query", query: query)
    end
    render json: { glossary_entries: entries.map { serialize(_1) } }
  end

  def show
    render json: serialize(entry)
  end

  def create
    record = GlossaryEntry.new(entry_attributes)
    GlossaryEntry.transaction do
      record.save!
      audit!(action: "glossary_entry.create", resource: record, changes: serialize(record))
    end
    render json: serialize(record), status: :created
  end

  def update
    GlossaryEntry.transaction do
      entry.update!(entry_attributes)
      audit!(action: "glossary_entry.update", resource: entry,
        changes: entry.previous_changes.slice("term", "definition"))
    end
    render json: serialize(entry)
  end

  def destroy
    GlossaryEntry.transaction do
      audit!(action: "glossary_entry.destroy", resource: entry, changes: serialize(entry))
      entry.destroy!
    end
    head :no_content
  end

  private

  def entry
    @entry ||= GlossaryEntry.find(params[:id])
  end

  def entry_attributes
    params.require(:glossary_entry).permit(:term, :definition)
  end

  def serialize(record)
    record.as_json(only: %i[id term definition created_at updated_at])
  end

  def duplicate_term
    render json: { error: "validation_failed", details: { term: [ "has already been taken" ] } },
      status: :unprocessable_entity
  end
end
