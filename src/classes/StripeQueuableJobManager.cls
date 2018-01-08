/**
 * Created by PeterChurchill on 2/7/2017.
 */

public with sharing class StripeQueuableJobManager implements Queueable, Database.AllowsCallouts {
   private id stripeRecordToProcess;
   
    public StripeQueuableJobManager(Id IdToProcess) {
        stripeRecordToProcess = IdToProcess;
    } 
    
    public StripeQueuableJobManager() {
    } 
    
   public void execute (QueueableContext context) {
      Stripe_Settings__c stripe_settings = Stripe_Settings__c.getorgdefaults();

      if (stripe_settings.Disable_Callout_Queue__c == TRUE) return;

       //List<Stripe_Data__c> stripedatatoprocess = [Select Id, Stripe_Id__c FROM Stripe_Data__c WHERE Processing_Status__c = 'Verify Data from Stripe' LIMIT 1];
		List<Stripe_Data__c> stripedatatoprocess = [Select Id, Stripe_Id__c FROM Stripe_Data__c WHERE Id = :stripeRecordToProcess];
                  
        if (stripedatatoprocess.size() == 0) return;
        
       	Stripe_Data__c currentrequest = stripedatatoprocess [0];

          StripeEventCallout  stripeeventcallout = new StripeEventCallout (currentrequest.Stripe_Id__c);
          stripeeventcallout.execute();
       
       /*
        * List<Stripe_Data__c> moreRequests = [
               Select ID
               from Stripe_Data__c
               where processing_status__c = 'Verify Data from Stripe' and ID <> :currentRequest.id
               Limit 1 ];

       if(moreRequests.size()==0) return;

       try {
           enqueuenewQueueJob(context.getJobId());
       }
       catch(Exception ex) {
           //tryToQueue();
       }
	*/
   }

    /*
     * public static void enqueuenewQueueJob(ID currentJobId)  {

        List<AsyncApexJob> jobs = [Select ID, Status, ExtendedStatus from AsyncApexJob
        where JobType = 'Queueable' And (status='Queued'  Or Status='Holding')
        and ApexClass.Name='StripeQueuableJobManager' and ID!= :currentJobId Limit 1 ];
        if(jobs.size()==1) return;  // Already have one queued that isn't this one.

        //system.enqueueJob(new StripeQueuableJobManager ());
    }
    
    public static void enqueueJobQueue()  {

        List<AsyncApexJob> jobs = [Select ID, Status, ExtendedStatus from AsyncApexJob
        where JobType = 'Queueable' And (status='Queued'  Or Status='Holding')
        and ApexClass.Name='StripeQueuableJobManager'];
        // If already have one queued so don't start new one
        system.debug(jobs.size());
        if (jobs.size() == 0) {
            //system.enqueueJob(new StripeQueuableJobManager ());
        }
    }
*/
}