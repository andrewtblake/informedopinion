import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    event.preventDefault()
    event.stopPropagation()
    this.element.focus()
  }

  hide(event) {
    event.preventDefault()
    this.element.blur()
  }
}
