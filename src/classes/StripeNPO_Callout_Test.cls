@isTest
public class StripeNPO_Callout_Test {

    @isTest 
    static void OutboundEventCalloutSuccess() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeChargeSucceeded_TEST');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<Stripe_Data__c> stripedata = new List<Stripe_Data__c>();
        stripedata.add(new Stripe_Data__c(
            stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ioq',
            Processing_Status__c = 'Verify Data from Stripe'));
       stripedata.add(new Stripe_Data__c(
        stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ior',
        Processing_Status__c = 'Verify Data from Stripe'));
        
        test.StartTest();
        insert stripedata;
        test.stopTest();
        
        // Verify response received contains values returned by
        // the mock response.
        // This is the content of the static resource.
        //System.assertEquals('{"hah":"fooled you"}', res.getBody());
        //System.assertEquals(200,res.getStatusCode());
        //System.assertEquals('application/json', res.getHeader('Content-Type'));   
    }
    
     @isTest 
    static void OutboundEventCalloutError() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeChargeBadError_TEST');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<Stripe_Data__c> stripedata = new List<Stripe_Data__c>();
        stripedata.add(new Stripe_Data__c(
            stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ioq',
            Processing_Status__c = 'Verify Data from Stripe'));
       stripedata.add(new Stripe_Data__c(
        stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ior',
        Processing_Status__c = 'Verify Data from Stripe'));
        
        test.StartTest();
        insert stripedata;
        test.stopTest();
        
        // Verify response received contains values returned by
        // the mock response.
        // This is the content of the static resource.
        //System.assertEquals('{"hah":"fooled you"}', res.getBody());
        //System.assertEquals(200,res.getStatusCode());
        //System.assertEquals('application/json', res.getHeader('Content-Type'));   
    }
    
    @isTest
    static void InboundEventFailure() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeChargeBadError_TEST');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
    
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/stripe/webhooks/v1/*';
        req.httpMethod = 'POST';
        //StaticResource sr = [Select Id, Body from StaticResource WHERE Name = 'StripeChargeBadError_TEST'];
        req.requestBody = Blob.Valueof(' ');
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        test.StartTest();
        WebhookListener.doPost();
        test.StopTest();
        }
    
    @isTest
    static void InboundEventSuccess() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeChargeSucceeded_TEST');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
    
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/stripe/webhooks/v1/*';
        req.httpMethod = 'POST';
        StaticResource sr = [Select Id, Body from StaticResource WHERE Name = 'StripeChargeSucceeded_TEST'];
        req.requestBody = sr.Body; // Add JSON Message as a POST
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        test.StartTest();
        WebhookListener.doPost();
        test.StopTest();
        }

    @isTest
    static void InboundInvoiceEventSuccess() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeInvoiceSucceeded_TEST');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        RestRequest req = new RestRequest();

        req.requestURI = '/services/apexrest/stripe/webhooks/v1/*';
        req.httpMethod = 'POST';
        StaticResource sr = [Select Id, Body from StaticResource WHERE Name = 'StripeInvoiceSucceeded_TEST'];
        req.requestBody = sr.Body; // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        test.StartTest();
        WebhookListener.doPost();
        test.StopTest();
    }

    @isTest
    static void InboundGetSuccess() {
        RestRequest req = new RestRequest();

        req.requestURI = '/services/apexrest/stripe/webhooks/v1/*';
        req.httpMethod = 'GET';

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        test.StartTest();
        WebhookListener.doGet();
        test.StopTest();
    }

    @isTest
    private static void settingsUpdatefromConfig() {

        //Mimic Install Script
        stripe_npo__Stripe_Settings__c kws = stripe_npo__Stripe_Settings__c.getOrgDefaults();
        insert kws;

            StripeSettingsController ssc = new StripeSettingsController();
            ssc.stripesettings.stripe_npo__Stripe_Secret_Test_Key__c = 'test 123';
            ssc.updateSettings();

            stripe_npo__Stripe_Settings__c stripesettingsconfirm = stripe_npo__Stripe_Settings__c.getOrgDefaults();
            system.assertEquals('test 123', stripesettingsconfirm.stripe_npo__Stripe_Secret_Test_Key__c);
            system.assertEquals(FALSE, stripesettingsconfirm.stripe_npo__Disable_Callout_Queue__c);

    }

    @isTest 
    static void StripeDataExtensionTest() {
        stripe_Settings__c stripe_settings = Stripe_Settings__c.getorgdefaults();
        stripe_settings.Disable_Callout_Queue__c = TRUE;
        insert stripe_settings;
    
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StripeChargeSucceeded_TEST');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<Stripe_Data__c> stripedata = new List<Stripe_Data__c>();
        stripedata.add(new Stripe_Data__c(
            stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ioq',
            Processing_Status__c = 'Verify Data from Stripe'));
       stripedata.add(new Stripe_Data__c(
        stripe_npo__Stripe_Id__c = 'evt_AO301v7FMi1ior',
        Processing_Status__c = 'Verify Data from Stripe'));
        insert stripedata;
        StripeDataControllerExtension sde = new StripeDataControllerExtension(new ApexPages.StandardController(stripedata[0]));
        
        test.StartTest();
        sde.getStripeData();
        sde.executeLocalUpdate();
        test.stopTest();
        
        // Verify response received contains values returned by
        // the mock response.
        // This is the content of the static resource.
        //System.assertEquals('{"hah":"fooled you"}', res.getBody());
        //System.assertEquals(200,res.getStatusCode());
        //System.assertEquals('application/json', res.getHeader('Content-Type'));   
    }
    
    @isTest
    static void InstallationScripts_TEST() {
    
        StripePostInstallScript postinstall = new   StripePostInstallScript();
        Test.testInstall(postinstall, null);
        
         stripe_npo__Stripe_Settings__c kws = stripe_npo__Stripe_Settings__c.getOrgDefaults();
         system.assertNotEquals(NULL, kws.Id);
    }
    
}