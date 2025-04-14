import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  preventPropagation(event) {
    event.stopPropagation()
  }
}