public with sharing class QuoteAFSConsumerController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'AFSRateV2__c';

        Map<String, List<AFSRateV2__c>> rates = new Map<String, List<AFSRateV2__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    //This method will use to return data record to green light table rates
    public static List<AFSRateV2__c> getRates() {
        
        return [SELECT t.Name,Asset_Type__c,t.Comm__c,t.Plan__c,t.Base_Rate__c, t.Rate__c,t.Risk_Grade__c,Condition__c
        from AFSRateV2__c t Where t.Plan__c != null And Asset_Type__c != null order by Asset_Type__c, t.Name];
    }

    @AuraEnabled
    public static Map<String, String> getApplications(String opportunityId){
        try {
            String typeOfAsset = '';
            String modeOfEmployment = '';

            //List<Application__r> app = List<Application__r>();
            Id applicationId = QuoteController.getOpportunityById(opportunityId).Application__c;
            System.debug('==> getApplications applicationId' + applicationId);
            if(applicationId != null){
                for(Application__c app :[SELECT Id, Type_of_Asset__c, Mode_of_Employment_1__c FROM Application__c WHERE Id =: applicationId]){
                    typeOfAsset = app.Type_of_Asset__c;
                    modeOfEmployment = app.Mode_of_Employment_1__c;
                }
            }
          System.debug('==> getApplications typeOfAsset ' + ' modeOfEmployment ' + modeOfEmployment);
          return new Map<String, String>{'typeOfAsset' => typeOfAsset,
                                          'modeOfEmployment' => modeOfEmployment
                                        };
        }
        catch (Exception e) {
          throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
        param.commRate = QuotingCalculation.getAFSRateCommission(param);
        param.vehiclePrice = getVehiclePrice(param);
        System.debug('==> calculateRepayments param '+ param);
        return QuoteController.calculateRepayments(param);
    }

    public static Decimal getVehiclePrice(QuotingCalculation.CalcParam param) {
        Decimal r = 0.0;
        r += (param.vehiclePrice != null)? param.vehiclePrice : 0;
        r -= param.netDeposit;
        return r;
    }

    @AuraEnabled
    public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
        param.vehiclePrice = getVehiclePrice(param);
        System.debug('==> calculateRepayments param '+ param);
        return QuoteController.getBaseRates(param);
    }
}