import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backGround"]

  connect() {
    // モーダルを表示状態にする
    this.openModal()
  }

  closeModal(event) {
    if (event) {
      event.preventDefault()
    }
    this.element.remove()
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

  close(event) {
    if (event.detail.success) {
      this.closeModal()
    } else {
      this.showValidationError()
    }
  }

  showValidationError() {
    alert("フォームにエラーがあります。もう一度確認してください。")
  }
}