import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static storageKey = "informed-opinion:moderation-disclosures"

  connect() {
    const savedState = this.readState()
    if (savedState === null) return

    this.disclosures.forEach((disclosure) => {
      const key = disclosure.dataset.disclosureKey
      if (Object.prototype.hasOwnProperty.call(savedState, key)) {
        disclosure.open = savedState[key]
      }
    })
  }

  remember() {
    const state = Object.fromEntries(this.disclosures.map((disclosure) => [
      disclosure.dataset.disclosureKey,
      disclosure.open
    ]))

    try {
      window.sessionStorage.setItem(this.constructor.storageKey, JSON.stringify(state))
    } catch (_error) {
      // Disclosure controls still work when browser storage is unavailable.
    }
  }

  get disclosures() {
    return Array.from(this.element.querySelectorAll("details[data-disclosure-key]"))
  }

  readState() {
    try {
      const value = window.sessionStorage.getItem(this.constructor.storageKey)
      return value === null ? null : JSON.parse(value)
    } catch (_error) {
      return null
    }
  }
}
