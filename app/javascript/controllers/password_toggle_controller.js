import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-toggle"
export default class extends Controller {
  static targets = ["input", "toggle"]

  connect() {
    this.updateToggleText()
  }

  toggle() {
    const type = this.inputTarget.type === "password" ? "text" : "password"
    this.inputTarget.type = type
    this.updateToggleText()
  }

  updateToggleText() {
    if (this.inputTarget.type === "password") {
      this.toggleTarget.textContent = "Show"
      this.toggleTarget.setAttribute("aria-label", "Show password")
      this.toggleTarget.classList.remove("password-visible")
    } else {
      this.toggleTarget.textContent = "Hide"
      this.toggleTarget.setAttribute("aria-label", "Hide password")
      this.toggleTarget.classList.add("password-visible")
    }
  }
}
