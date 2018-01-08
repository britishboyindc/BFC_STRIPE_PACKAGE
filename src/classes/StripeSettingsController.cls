public with sharing class StripeSettingsController {

public stripe_npo__Stripe_Settings__c stripesettings {get;set;}
 
public StripeSettingsController () {
    stripesettings = stripe_npo__Stripe_Settings__c.getOrgDefaults();
}
 
public pageReference updateSettings() {
    update stripesettings ;
    return null;
}
    
    
}