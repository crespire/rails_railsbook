import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-display"
export default class extends Controller {
  hide() {
    this.element.remove();
  }
}
