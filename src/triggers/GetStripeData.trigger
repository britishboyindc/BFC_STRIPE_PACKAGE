trigger GetStripeData on Stripe_Data__c (after insert) {

Stripe_Settings__c stripe_settings = Stripe_Settings__c.getorgdefaults();

if (stripe_settings.Disable_Callout_Queue__c != TRUE) {
    if (Trigger.IsInsert && Trigger.IsAfter && Trigger.New.Size() == 1) {
        for (Stripe_Data__c sTemp: Trigger.New) {
    		system.enqueueJob(new StripeQueuableJobManager (sTemp.Id));
        }
    }
    //StripeQueuableJobManager.enqueueJobQueue();
    //StripeQueuableJobManager
}

}