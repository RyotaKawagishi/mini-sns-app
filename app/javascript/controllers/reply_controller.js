import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "list"]

  connect() {
    console.log("Stimulus reply controller connected")
    this.inputTarget.addEventListener("input", () => {
      const val = this.inputTarget.value;
      const option = [...this.listTarget.options].find(o => o.value === val);
      this.hiddenTarget.value = option ? option.dataset.id : "";
    });
  }
}