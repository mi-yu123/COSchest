// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import "trix"
import "@rails/actiontext"


// Turboのナビゲーション処理をカスタマイズ
document.addEventListener("turbo:before-fetch-request", (event) => {
  const fetchOptions = event.detail.fetchOptions
  
  // OmniAuthのリクエストの場合は特別な処理
  if (event.target.getAttribute("data-turbo") === "false") {
    event.preventDefault()
    return false
  }
})

// エラーハンドリング
document.addEventListener("turbo:load", (event) => {
  console.log("Page loaded via Turbo")
})

document.addEventListener("turbo:fetch-request-error", (event) => {
  console.error("Turbo fetch request error:", event.detail.error)
})