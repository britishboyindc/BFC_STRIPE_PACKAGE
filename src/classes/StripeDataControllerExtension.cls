public class StripeDataControllerExtension {

    public StripeWebhookRetrieval webhook {get;set;}
	private final Stripe_Data__c stripedata;
    private String sWebhookResponse;
    StripeMetaDataUtility scmd;

    public StripeDataControllerExtension (ApexPages.StandardController stdController) {
    	this.stripedata = (Stripe_Data__c)stdController.getRecord();
        scmd = new StripeMetaDataUtility();
    }

    public pagereference getStripeData () {
        webhook = new StripeWebhookRetrieval();
        Boolean bValid = webhook.getEventById(stripedata.Stripe_Id__c);

        if (bValid == TRUE) {
            stripedata.JSON_Response__c = webhook.response;
            stripedata.Processing_Status__c = 'Verified Successfully';
        }
        else {
            stripedata.Processing_Status__c = 'Error with Verification';

        }
        update stripedata;
        return null;
    }
    
    public pagereference executeLocalUpdate () {
        try{
            scmd.stripedata = this.stripedata;
            scmd.parseStripeEvent();
            stripedata.Processing_Status__c = 'Imported Successfully';
        }
        catch (Exception Ex) {
            system.debug(ex);
            stripedata.Processing_Status__c = 'Error with Import';
        }
        update stripedata;
        return null;
    }

}