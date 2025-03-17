import { Controller } from "@hotwired/stimulus";

let init = false;

export default class SessionController extends Controller {
    connect() {
        if (init) return;

        if (!init) {
            init = true;
        }

        const object = this;
        document.addEventListener('turbo:submit-end', function(event) {
            object.handleTurboSubmitEnd(event).then(r => r).catch(err => window.location.href = '/');
        });

        this.messageTarget = document.getElementById('message');
    }

    submitForm (event) {
        return true;
    }

    async handleTurboSubmitEnd(event) {
        const { detail } = event;
        const { success, fetchResponse } = detail;

        if (detail.mustRedirect) {
            window.location.href = '/';
        } else {
            const response = await fetchResponse.response.json();
            this.showMessage(response.alert, 'alert-danger');
        }
    }

    showMessage(message, type) {
        const messageDiv = document.createElement("div");
        messageDiv.classList.add("alert", type, "d-flex", "justify-content-between", "align-items-center");
        messageDiv.innerHTML = `
          <span>${message}</span>
          <button type="button" class="btn-close" data-action="click->session#dismiss" aria-label="Close"></button>
        `;

        this.messageTarget.appendChild(messageDiv);

        setTimeout(() => this.dismiss(), 5000);
    }

    dismiss() {
        if (this.messageTarget.children.length > 0) {
            this.messageTarget.firstElementChild.remove();
        }
    }

    close(event) {
        event.target.closest('.alert').remove();
    }
}