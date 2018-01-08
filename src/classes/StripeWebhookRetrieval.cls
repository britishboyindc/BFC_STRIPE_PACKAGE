public class StripeWebhookRetrieval { 
	public String response {get;set;}

    //private static final String SERVICE_URL = 'https://api.stripe.com/v1/events';
    Map<String, String> error;

public Boolean getEventById(String eventId) {
    Boolean bValidEvent;
    HttpRequest http = new HttpRequest();
        //String endPoint = SERVICE_URL+'/'+eventId;
        //if (expandInvoice) endPoint += '?expand[]=invoice';
        //System.debug(System.LoggingLevel.INFO, '\n**** StripeCharge.getEvent endpoint: '+endPoint);
        //http.setEndpoint(endPoint);
        http.setEndpoint('callout:stripe_npo__Stripe_API_1/events/' + eventId);

        http.setMethod('GET');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);


        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        //StripeEvent retrievedevent;
        
              try {
                hs = con.send(http);
            } catch (CalloutException e) {
                //return null;
            }

        statusCode = hs.getStatusCode();
        
        try {
            response = hs.getBody();
            system.debug('####2 '+ response);

            bValidEvent = TRUE;
            }
        catch (System.Exception e) {
                System.debug(System.LoggingLevel.INFO, '\n**** Exception: '+e);
                bValidEvent = FALSE;
                error = new Map<String, String>{
                    'type' => e.getTypeName(), 
                    'error' => e.getMessage()
                };
            
            }
        return bValidEvent;
}
}