public without sharing class QuoteWisrPLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
        ? param.rateSettings.get(0) : 'Direct_Money_Rate__c';
        
        Map<String, List<Direct_Money_Rate__c>> rates = new Map<String, List<Direct_Money_Rate__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;

        return r;
    }

    public static List<Direct_Money_Rate__c> getRates() {
        List<Direct_Money_Rate__c> d = Direct_Money_Rate__c.getAll().values();
        d.sort();
        List<Direct_Money_Rate__c> r = new List<Direct_Money_Rate__c>();
        for (Direct_Money_Rate__c a : d) {
            if ('>= 90'.equals(a.LVR__c)) {
                r.add(a);
            }
        }
        return r;
    }
}