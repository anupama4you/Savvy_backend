public without sharing class QuoteFirstmacController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'FirstmacRate__c';

        Map<String, List<FirstmacRate__c>> rates = new Map<String, List<FirstmacRate__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    public static List<FirstmacRate__c> getRates() {
        List<FirstmacRate__c> res = new List<FirstmacRate__c>();
        List<FirstmacRate__c> rates = FirstmacRate__c.getAll().values();
        if(rates != NULL && !rates.isEmpty()){
            rates.sort();
            for (FirstmacRate__c fm: rates) {
                    res.add(fm);
            }
        }
        return res;
    }

    @AuraEnabled
    public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
        Decimal br = 0.00;
        Decimal max = 0.00;

        //get base rate
        br = QuotingCalculation.getBaseRate(param);
        if (param.hasMaxRate != null && param.hasMaxRate) {
            //get max rate
            max = QuotingCalculation.getMaximunBaseRate(param);
        }
    
        return new Map<String, Decimal>{'baseRate' => br, 
                                        'maxRate' => max
                                    };

    }
}