/**
 * Created by PeterChurchill on 3/29/2017.
 */

public with sharing class StripeMetaDataUtility {
    public Map<String, Map<String, stripe_npo__Stripe_Field_Mapping__mdt> > stripeFieldMap;
    public Stripe_Data__c stripedata;

    public StripeMetaDataUtility() {
        setupMetaDataMap();
    }
    public void parseStripeEvent() {

        Map<String, Object> responsemap = (Map<String, Object>) json.deserializeUntyped(stripedata.JSON_Response__c);
        try {
            Map<String, Object> mdatamap = (Map<String, Object>) (responsemap.get('data'));
                Map<String, Object> stripeobjectmap = (Map<String, Object>) (mdatamap.get('object'));
                Map<String, Object> stripeobjectmapchild ;

                 Map<String, stripe_npo__Stripe_Field_Mapping__mdt> cmTemp;

                if (stripeobjectmap.containskey ('object')) {
                    //Get Object Map from Meta Data e.g. Charge or Invoice
                    String stripeobjectname = (String) stripeobjectmap.get('object');
                    if (stripeFieldMap.containskey(stripeobjectname)) {
                        processStripeDataMap(stripeobjectname, stripeobjectmap);

                        //Some objects have child objects =- parse where applicable
                        if (stripeobjectmap.containskey('source')) {
                            stripeobjectmapchild = (Map<String, Object>) (stripeobjectmap.get('source'));
                            processStripeDataMap('card', stripeobjectmapchild);
                        }

                        if (stripeobjectmap.containskey('plan')) {
                            stripeobjectmapchild = (Map<String, Object>) (stripeobjectmap.get('plan'));
                            processStripeDataMap('plan', stripeobjectmapchild);
                        }

                        if (stripeobjectmap.containskey('lines')) {
                            Map<String, Object> stripeobjectlinemap = (Map<String, Object>) (stripeobjectmap.get('lines'));
                            if (stripeobjectlinemap.containskey('data')) {
                                List<Object> stripedataline = (List<Object>) (stripeobjectlinemap.get('data'));
                                Map<String, Object> stripedatalinemap = (Map<String, Object>) (stripedataline[0]);

                                if (stripedatalinemap.containskey('plan') ) {
                                    stripeobjectmapchild = (Map<String, Object>) stripedatalinemap.get('plan');
                                    processStripeDataMap('plan', stripeobjectmapchild);
                                    processStripeDataMap('invoice_item', stripedatalinemap);
                                }

                                //if (stripedatalinemap.containskey('metadata')) {
                                //    processStripeDataMap('invoice_item', (Map<String, Object>)stripedatalinemap.get('metadata'));
                                //}


                            }
                        }
                    }
                }

        }

    Catch (Exception Ex) {
        system.debug(ex);
    }

    }


    public void  processStripeDataMap(String sStripeType, Map<String, Object> stripeobjectmap) {
        //Build Map of Stripe Field in JSON to Metadata Mapping
        Map<String, stripe_npo__Stripe_Field_Mapping__mdt> cmTemp = stripeFieldMap.get(sStripeType);
        system.debug('Fields to Process' + cmTemp.keyset());
        system.debug('Data Keys to Process' + stripeobjectmap.keyset());
        //Loop through all fields in Stripe Object e.g. card or charge
        for (String s: cmTemp.keyset()) {

            //Does Stripe Object contain this Stripe API Field Name - if so process based on metadata mapping
            if (stripeobjectmap.containskey(s)) {

                system.debug(stripeobjectmap.get(s) + ' goes to' + cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c);
                if (cmTemp.get(s).stripe_npo__Data_Type__c == 'String') {
                	    stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c, (String) stripeobjectmap.get(s));
                    	//stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field__r.QualifiedAPIName, (String) stripeobjectmap.get(s));
                }
                if (cmTemp.get(s).stripe_npo__Data_Type__c == 'Map') {

                    Map<String, Object> tempMap = (Map<String, Object>) stripeobjectmap.get(s);
                    system.debug(tempMap);
                    system.debug(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c);
                    stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c, json.serializePretty(tempMap));
                    //Now try and parse the metadata
                    Map<String, stripe_npo__Stripe_Field_Mapping__mdt> cmMetaTemp = stripeFieldMap.get('metadata');
                    system.debug(cmMetaTemp);
                    for (String smeta: cmMetaTemp.keyset()) {
                        if (tempMap.containskey(smeta)) {
                            stripedata.put(cmMetaTemp.get(smeta).stripe_npo__Stripe_Data_Field_Text__c, (String)tempMap.get(smeta));
                        }
                    }
                }

                if (cmTemp.get(s).stripe_npo__Data_Type__c == 'Boolean') {
                    stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c, (Boolean) stripeobjectmap.get(s));
                }
                if (cmTemp.get(s).stripe_npo__Data_Type__c == 'Currency') {
                    Double dAmount = (Double) stripeobjectmap.get(s) / 100;
                    stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c, dAmount);
                }
                if (cmTemp.get(s).stripe_npo__Data_Type__c == 'Date') {
                    Date dttemp = getDate ( (Integer) stripeobjectmap.get(s));
                    stripedata.put(cmTemp.get(s).stripe_npo__Stripe_Data_Field_Text__c, dttemp);
                }



            }
        }

    }



    public static Date getDate(Integer dt) {
        String s = String.valueOf(dt)+'000';
        Long l = Long.valueOf(s);

        return DateTime.newInstance(l).date();
    }

    public void setupMetaDataMap() {

        stripeFieldMap = new Map<String, Map<String, stripe_npo__Stripe_Field_Mapping__mdt> >();

        for (stripe_npo__Stripe_Field_Mapping__mdt cmd: [
                SELECT
                        Label,
                        //stripe_npo__Stripe_Data__c,
                        //stripe_npo__Stripe_Data_Field__c,
                        //stripe_npo__Stripe_Data_Field__r.QualifiedAPIName,
                        stripe_npo__Stripe_API_Field_Name__c,
                        stripe_npo__Stripe_Data_Field_Text__c,
                        stripe_npo__Stripe_Object__c,
                        stripe_npo__Data_Type__c
                FROM stripe_npo__Stripe_Field_Mapping__mdt
        ]) {

            Map<String, stripe_npo__Stripe_Field_Mapping__mdt> tempmap;

            if (stripeFieldMap.containskey(cmd.stripe_npo__Stripe_Object__c)) {
                tempmap = stripeFieldMap.get(cmd.stripe_npo__Stripe_Object__c);
            } else {
                tempmap = new Map<String, stripe_npo__Stripe_Field_Mapping__mdt>();
            }
            tempmap.put(cmd.stripe_npo__Stripe_API_Field_Name__c, cmd);

            stripeFieldMap.put(cmd.stripe_npo__Stripe_Object__c, tempmap);
        }
    }

}