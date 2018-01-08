global with sharing class StripePostInstallScript implements InstallHandler {

global void onInstall(InstallContext context) {
      stripe_npo__Stripe_Settings__c kws = stripe_npo__Stripe_Settings__c.getOrgDefaults();
        if(context.previousVersion() == null) {
            if (kws.Id == NULL) {
                insert kws;
            }
        }
        
      }
   
} //end class