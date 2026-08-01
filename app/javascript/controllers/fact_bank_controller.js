import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  load() {
    if (!this.element.open) return

    const frame = this.element.querySelector("turbo-frame[data-source-url]")
    if (!frame) return

    const url = new URL(frame.dataset.sourceUrl, window.location.origin)
    url.searchParams.set("refresh", Date.now().toString())
    frame.src = url.toString()
  }
}
