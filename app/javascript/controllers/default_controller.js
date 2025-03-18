import { Controller } from "@hotwired/stimulus";

export default class DefaultController extends Controller {
    connect() {
        console.log(this.name + " connected");
    }

    navigate(event) {
        event.preventDefault();

        const url = event.currentTarget.href;
        if (url) {
            this.loadPage(url);
        }
    }

    async loadPage(url) {
        try {
            const response = await fetch(url, {
                headers: {
                    "Turbo-Frame": "main-content",
                },
            });

            if (response.ok) {
                const html = await response.text();
                document.querySelector("#main-content").innerHTML = html;
            } else {
                console.error("Failed to load page:", response.status);
            }
        } catch (error) {
            console.error("Error loading page:", error);
        }
    }
}