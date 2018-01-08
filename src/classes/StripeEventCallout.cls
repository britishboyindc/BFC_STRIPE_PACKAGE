public class StripeEventCallout {

private String eventIdToProcess;
StripeWebhookRetrieval webhook;
Stripe_Data__c stripedata;
StripeMetaDataUtility scmd;

    public StripeEventCallout(String eventId) {
        eventIdToProcess = eventId;
    }
    
public void execute() {
    webhook = new StripeWebhookRetrieval();
    Boolean bValid = webhook.getEventById(eventIdToProcess);
    stripedata  = new Stripe_Data__c();
    stripedata.Stripe_Id__c = eventIdToProcess;

    if (bValid == TRUE) {
        stripedata.JSON_Response__c = webhook.response;
        stripedata.Processing_Status__c = 'Verified Successfully';
    }
    else {
        stripedata.Processing_Status__c = 'Error with Verification';
        return;
    }

    try{
        scmd = new StripeMetaDataUtility();
        scmd.stripedata = this.stripedata;
        scmd.parseStripeEvent();
        stripedata.Processing_Status__c = 'Imported Successfully';
        }
        catch (Exception Ex) {
            system.debug(ex);
            stripedata.Processing_Status__c = 'Error with Import';
        }

    upsert stripedata Stripe_Id__c ;
    }

}