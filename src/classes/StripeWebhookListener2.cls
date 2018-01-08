public virtual class StripeWebhookListener2 {
   Stripe_Data__c stripedata;

    public String handleGet() {
        return 'OK';
    }

    public void handlePost() {
        RestResponse response = RestContext.response;
        response.addHeader('Content-type','application/json');
        System.debug(System.LoggingLevel.INFO, '\n**** '+RestContext.request.requestBody.toString());

        try {
            
            Map<String, Object> m = (Map<String, Object>)json.deserializeUntyped(RestContext.request.requestBody.toString());
            system.debug(m);
            stripedata = new Stripe_Data__c();
            stripedata.stripe_npo__Stripe_Id__c = (String)m.get('id');
            stripedata.Stripe_Event_Type__c = (String)m.get('type');
            stripedata.Processing_Status__c = 'Verify Data from Stripe';
            stripedata.Stripe_Live_Mode__c =  (Boolean)m.get('livemode');
            
            stripedata.JSON_Response__c = RestContext.request.requestBody.toString();
            
            }
        catch (System.Exception e) {
                System.debug(System.LoggingLevel.INFO, '\n**** Exception: '+e); 
    
                Map<String, String> error = new Map<String, String>{
                    'type' => e.getTypeName(), 
                    'error' => e.getMessage()
                };
                response.responseBody = Blob.valueOf(JSON.serializePretty(error));
                response.statusCode = 500;
                return;
            }

        // prevent tests from hitting production
        if (stripedata.Stripe_Live_Mode__c == false && StripeAPI.isTest == false) {
            System.debug(System.LoggingLevel.INFO, '\n**** Bailing out'); 
            return;
        }

        System.debug(System.LoggingLevel.INFO, '\n**** Event Type in Listener: '+stripedata.Stripe_Event_Type__c); 

        try {
               
                upsert stripedata stripe_npo__Stripe_Id__c ;
                response.responseBody = Blob.valueOf(JSON.serializePretty(stripedata));
                response.statusCode = 200;
                return;
           
            }
        catch (Exception Ex) {
        system.debug(Ex);
        response.responseBody = Blob.valueOf(ex.getMessage());
        response.statusCode = 200;
        return;
        }
       }    
}