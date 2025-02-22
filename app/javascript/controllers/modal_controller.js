import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review-modal"
export default class extends Controller {
  // ターゲットの定義
  static targets = ["modal", "backGround"];

  // connectメソッドは、コントローラに繋がれた時に呼ばれる
  connect() {
    // 初期化や追加処理があればここに書きます（今回は特にありません）
  }

  // フォームが送信されたときのアクション
  close(event) {
    // event.detail.success はレスポンスが成功なら true を返します
    if (event.detail.success) {
      // 成功時、モーダルを閉じる
      this.closeModal();
    } else {
      // バリデーションエラーがあった場合
      this.showValidationError();
    }
  }

  // モーダルを閉じる
  closeModal() {
    this.modalTarget.classList.add("hidden");
    this.backGroundTarget.classList.add("hidden");
  }

  // モーダルの外をクリックした際に閉じる
  closeBackground(event) {
    if (event.target === this.backGroundTarget) {
      this.closeModal();
    }
  }

  // モーダルを開く
  openModal() {
    this.modalTarget.classList.remove("hidden");
    this.backGroundTarget.classList.remove("hidden");
  }

  // バリデーションエラーがある場合の処理
  showValidationError() {
    alert("フォームにエラーがあります。もう一度確認してください。");
    // 必要に応じてバリデーションエラーを表示する処理を追加できます
  }
}
