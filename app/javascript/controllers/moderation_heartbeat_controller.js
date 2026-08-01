import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    heartbeatUrl: String,
    markUrl: String,
    moderationUrl: String,
    interval: { type: Number, default: 30000 }
  }

  connect() {
    this.visibilityHandler = () => {
      if (document.visibilityState === "visible") this.poll()
    }
    document.addEventListener("visibilitychange", this.visibilityHandler)
    this.timer = window.setInterval(() => {
      if (document.visibilityState === "visible") this.poll()
    }, this.intervalValue)
    window.requestAnimationFrame(() => this.poll())
  }

  disconnect() {
    document.removeEventListener("visibilitychange", this.visibilityHandler)
    window.clearInterval(this.timer)
  }

  sectionToggled(event) {
    if (event.currentTarget.open) this.poll()
  }

  async poll() {
    if (this.polling) return
    this.polling = true

    try {
      const response = await fetch(this.heartbeatUrlValue, {
        headers: { "Accept": "application/json" },
        credentials: "same-origin"
      })
      if (!response.ok) return

      const heartbeat = await response.json()
      if (this.onModerationPage) {
        this.setNavCount(0)
        await this.updateModerationPage(heartbeat.sections)
      } else {
        this.setNavCount(heartbeat.total)
      }
    } finally {
      this.polling = false
    }
  }

  async updateModerationPage(sections) {
    let freshDocument = null

    for (const [sectionId, state] of Object.entries(sections)) {
      const section = document.getElementById(sectionId)
      if (!section) continue

      if (!section.open) {
        this.setSectionCount(section, state.count)
        continue
      }

      if (state.items.length === 0) {
        this.setSectionCount(section, 0)
        continue
      }

      const needsFreshMarkup = state.items.some((item) => {
        const existing = this.itemNode(document, item.key)
        return !existing || existing.dataset.moderationItemVersion !== item.version
      })
      if (needsFreshMarkup && freshDocument === null) freshDocument = await this.fetchModerationDocument()

      const displayed = state.items.filter((item) => this.displayItem(section, item, freshDocument))
      if (displayed.length === 0) {
        this.setSectionCount(section, state.count)
        continue
      }

      if (await this.markDisplayed(displayed)) {
        this.setSectionCount(section, Math.max(0, state.count - displayed.length))
      } else {
        this.setSectionCount(section, state.count)
      }
    }
  }

  displayItem(section, item, freshDocument) {
    let current = this.itemNode(document, item.key)
    const fresh = freshDocument && this.itemNode(freshDocument, item.key)

    if (!current && fresh) {
      current = document.importNode(fresh, true)
      const empty = section.querySelector(":scope > .moderation-empty")
      if (empty) empty.remove()
      section.append(current)
    } else if (current && current.dataset.moderationItemVersion !== item.version) {
      if (!fresh || this.hasDirtyEditor(current)) {
        this.showUpdateWarning(current)
        return false
      }
      const replacement = document.importNode(fresh, true)
      current.replaceWith(replacement)
      current = replacement
    }

    if (!current || current.dataset.moderationItemVersion !== item.version) return false

    this.highlight(current)
    return true
  }

  async fetchModerationDocument() {
    const response = await fetch(this.moderationUrlValue, {
      headers: { "Accept": "text/html" },
      credentials: "same-origin"
    })
    if (!response.ok) return null

    return new DOMParser().parseFromString(await response.text(), "text/html")
  }

  async markDisplayed(items) {
    const response = await fetch(this.markUrlValue, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || ""
      },
      credentials: "same-origin",
      body: JSON.stringify({ items })
    })
    return response.ok
  }

  itemNode(root, key) {
    return root.querySelector(`[data-moderation-item-key="${CSS.escape(key)}"]`)
  }

  hasDirtyEditor(node) {
    return Array.from(node.querySelectorAll("textarea, select, input:not([type='hidden'])")).some((field) => {
      if (field.type === "checkbox" || field.type === "radio") return field.checked !== field.defaultChecked
      return field.value !== field.defaultValue
    })
  }

  showUpdateWarning(node) {
    if (node.querySelector(":scope > .moderation-update-warning")) return
    const warning = document.createElement("p")
    warning.className = "moderation-update-warning"
    warning.textContent = "Updated elsewhere. Finish or discard the current edit before this item refreshes."
    node.prepend(warning)
  }

  highlight(node) {
    node.classList.add("moderation-new-item")
    window.setTimeout(() => node.classList.remove("moderation-new-item"), 2000)
  }

  setNavCount(count) {
    const badge = document.querySelector("[data-moderation-nav-badge]")
    if (badge) this.setBadge(badge, count, `${count} unseen moderation items`)
  }

  setSectionCount(section, count) {
    let badge = section.querySelector(":scope > summary .moderation-notification-badge")
    if (!badge && count > 0) {
      badge = document.createElement("span")
      badge.className = "moderation-notification-badge"
      badge.dataset.dynamicBadge = "true"
      section.querySelector(":scope > summary")?.append(badge)
    }
    if (badge) this.setBadge(badge, count, `${count} unseen items in this section`)
  }

  setBadge(badge, count, label) {
    badge.hidden = count === 0
    badge.textContent = count > 9 ? "9+" : count.toString()
    badge.setAttribute("aria-label", label)
  }

  get onModerationPage() {
    return Boolean(document.querySelector(".moderation-page[data-moderation-page]"))
  }
}
