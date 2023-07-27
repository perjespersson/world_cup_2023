import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(document.getElementById('modal'))
    this.userId = this.data.get("user");
  }

  openModal() {
    fetch(`/bets/user_bets/${this.userId}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => {
      return response.text();
    })
    .then(turboStreamContent => {
      const turboFrameElement = document.getElementById("user_bets");
      turboFrameElement.innerHTML = turboStreamContent;
      this.modal.show();
    })
    .catch(error => {
      console.error("Error fetching user bets:", error);
    });
  }
}
