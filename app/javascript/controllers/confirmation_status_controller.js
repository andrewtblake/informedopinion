import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = [ "waiting", "confirmed" ]

  connect() {
    this.check()
    this.timer = window.setInterval(() => this.check(), 2500)
  }

  disconnect() {
    window.clearInterval(this.timer)
  }

  async check() {
    if (document.hidden) return

    try {
      const response = await fetch(this.urlValue, {
        headers: { Accept: "application/json" },
        credentials: "same-origin"
      })
      if (!response.ok) return

      const status = await response.json()
      if (status.signed_in) {
        window.location.replace(status.continue_url)
      } else if (status.confirmed) {
        window.clearInterval(this.timer)
        this.waitingTarget.hidden = true
        this.confirmedTarget.hidden = false
        this.confirmedTarget.focus()
      }
    } catch (_error) {
      // A temporary network failure should not interrupt the waiting page.
    }
  }
}
