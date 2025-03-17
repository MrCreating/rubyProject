import { Controller } from "@hotwired/stimulus";

import SessionController from 'controllers/session_controller'

export default class RegistrationController extends SessionController {
    connect() {
        return super.connect();
    }

    submitForm(event) {
        return super.submitForm(event);
    }
}