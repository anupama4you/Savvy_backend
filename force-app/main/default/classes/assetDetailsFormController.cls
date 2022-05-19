public with sharing class assetDetailsFormController {
   
    @AuraEnabled(cacheable=true)
    public static List<Custom_Opportunity__c> getCustomOpportunities(String recordId) {
        system.debug('::::: Id :::::' + recordId);
        return [select Id, Name Application__c, Purchase_Type__c, Dealer_Name__c, Dealer_Contact_Name__c, Dealer_Email__c, 
        Dealer_Phone_Number__c, Dealer_Mobile__c, Dealer_Unit_Number__c, Dealer_Street_Number__c, Dealer_Address__c,
         Dealer_Street_Type__c, Dealer_Suburb__c, Dealer_Postcode__c, Dealer_State__c , 
         Application_AssetDetail__r.Search_Certificate_Number__c, Application_AssetDetail__r.PPSR_Proxy_Message__c, 
         Application_AssetDetail__r.Actual_KM__c, Application_AssetDetail__r.Condition__c, Application_AssetDetail__r.Deposit__c, 
         Application_AssetDetail__r.Factory_Options__c, Application_AssetDetail__r.Fees__c, Application_AssetDetail__r.GAP__c,
          Application_AssetDetail__r.Lender__c, Application_AssetDetail__r.Type_Loan__c, Application_AssetDetail__r.LPI__c, 
          Application_AssetDetail__r.LTI__c, Application_AssetDetail__r.LVR__c, Application_AssetDetail__r.Make__c, 
          Application_AssetDetail__r.Model__c, Application_AssetDetail__r.NAF__c, Application_AssetDetail__r.Price__c,
           Application_AssetDetail__r.RRP__c, Application_AssetDetail__r.Series__c, Application_AssetDetail__r.Type__c, 
           Application_AssetDetail__r.Variant__c, Application_AssetDetail__r.Warranty__c, Application_AssetDetail__r.Year__c,
            Application_AssetDetail__r.Rego__c, Application_AssetDetail__r.VIN__c, Application_AssetDetail__r.Engine_No__c, 
            Application_AssetDetail__r.Colour__c, Application_AssetDetail__r.Rego_State__c,
             Application_AssetDetail__r.Redbook_Key__c, Application_AssetDetail__r.Variant_Desc__c,
              Application_AssetDetail__r.PPSR_Proxy_Id__c, Application_AssetDetail__r.PPSR_Proxy_Last_Update__c, 
              Owner_Email__c, Loan_Product__c, Contract_Number__c, Dealer_Type__c  from Custom_Opportunity__c WHERE Id = :recordId LIMIT = 1];
    }

    @AuraEnabled(cacheable=true)
    public static List <CustomSelectOption> getYears(String newUsed) {
        return getYears(newUsed.toLowerCase(), 'Car');
    }

    @AuraEnabled(cacheable=true)
    public static List <CustomSelectOption> getYears(String newUsed, String assetType) {
        List <CustomSelectOption> r = new List <CustomSelectOption>();
        Integer yActual = Date.today().year();
        if (newUsed != null) {
            r.add(new CustomSelectOption ('', '--None--'));
            if ('new'.equals(newused) || 'demo'.equals(newused)) {
                for (Integer y = yActual; y >= yActual-2;y--) {
                    r.add(new CustomSelectOption(String.valueOf(y),String.valueOf(y)));
                }
            } else if ('used'.equals(newused)) {
                Integer z = 1960; //Limit for Cars
                if (!'Car'.equalsIgnoreCase(assetType)) {
                    z = yActual - 30;
                }
                // for (Integer y=yActual; y > (yActual - z);y--) {
                for (Integer y=yActual; y >= z;y--) {
                    r.add(new CustomSelectOption(String.valueOf(y),String.valueOf(y)));
                }
            }
        }
        return r;
    }
}
