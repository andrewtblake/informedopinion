import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { authenticated: Boolean }

  connect() {
    const draft = this.readDraft()
    if (!draft) return

    this.fields.forEach((field) => {
      if (!field.value && draft[field.name]) field.value = draft[field.name]
    })
  }

  save() {
    const draft = {}
    this.fields.forEach((field) => { draft[field.name] = field.value })
    localStorage.setItem(this.storageKey, JSON.stringify(draft))
  }

  submitted(event) {
    if (this.authenticatedValue && event.detail.success) localStorage.removeItem(this.storageKey)
  }

  readDraft() {
    try {
      return JSON.parse(localStorage.getItem(this.storageKey))
    } catch (_error) {
      localStorage.removeItem(this.storageKey)
      return null
    }
  }

  get fields() {
    return Array.from(this.element.elements).filter((field) =>
      field.name?.startsWith("opinion_question_proposal[") && field.type !== "submit"
    )
  }

  get storageKey() {
    return "opinion-question-proposal-draft"
  }
}
