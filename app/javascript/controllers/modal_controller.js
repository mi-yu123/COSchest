import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backGround", "taskList", "form"]

  connect() {
    this.openModal()
  }

  closeModal(event) {
    if (event) {
      event.preventDefault()
    }
    this.element.remove() // モーダル要素を完全に削除
  }

  closeBackground(event) {
    if (event.target === this.backGroundTarget) {
      this.closeModal()
    }
  }

  openModal() {
    this.modalTarget.classList.remove("hidden")
    this.backGroundTarget.classList.remove("hidden")
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.closeModal()
    }
  }
}