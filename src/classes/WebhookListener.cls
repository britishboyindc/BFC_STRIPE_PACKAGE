@RestResource(urlMapping='/stripe/webhooks/v1/*')
global class WebhookListener extends StripeWebhookListener2 {

    @HttpPost
    global static void doPost() {
        WebhookListener listener = new WebhookListener();
        listener.handlePost();
    }

    @HttpGet
    global static String doGet() {
        WebhookListener listener = new WebhookListener();
        return listener.handleGet();

    }

}