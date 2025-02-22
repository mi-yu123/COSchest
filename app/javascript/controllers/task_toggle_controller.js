import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "status"]
  static values = { taskId: Number }

  toggle() {
    const url = `/tasks/${this.taskIdValue}/toggle`
    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
        'Accept': 'text/vnd.turbo-stream.html'
      },
      credentials: 'same-origin'
    })
  }
}