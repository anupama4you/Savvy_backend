public without sharing class QuoteAFSCommercialController {
    
    public class AfsRate {
        @AuraEnabled
    	public Decimal rate {set;get;}
        @AuraEnabled
    	public Decimal comm {set;get;}

    	public AfsRate(Decimal rate, Decimal comm) {
    		this.rate = rate;
    		this.comm = comm;
    	}
    }
    
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {  
      return QuoteController.getQuotingData(param); 
    }

    public static Map<String, List<AfsRate>> getRates(){
        Map<String, List<AfsRate>> rates = new Map<String, List<AfsRate>>();
        List<AFS_Commercial_Rates__c> fullRates = AFS_Commercial_Rates__c.getAll().values();
        if(!fullRates.isEmpty()){
            fullRates.sort();
            List<AfsRate> r1 = new List<AfsRate>();
            List<AfsRate> r2 = new List<AfsRate>();
            
            for (AFS_Commercial_Rates__c a : fullRates) {
                r1.add(new AfsRate(a.Rate__c, a.Comm_07_Years__c));
                r2.add(new AfsRate(a.Rate_2__c, a.Comm_8_Years__c));
            }
            rates.put('New - 6 years old', r1);
            rates.put('Used 7 years+', r2);
        }
        return rates; 
    }

    @AuraEnabled
    public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
        param.commRate = getCommissionRate(param);
        System.debug('==> calculateRepayments param '+ param);
        return QuoteController.calculateRepayments(param);
    }

    public static Decimal getCommissionRate(QuotingCalculation.CalcParam param) {
        Map<String, List<AfsRate>> rateList = getRates();
        Decimal r = 0.0;
        if (param.clientRate != 0 && !rateList.isEmpty()) {
            List<AfsRate> rts = rateList.get(param.assetAge);
        	for (AfsRate a : rts) {
        		if(param.clientRate >= a.rate) {
        			r = a.comm;
        		}
        	}
        }
        return r;
    }

    @AuraEnabled
    public static List<AfsRate> getAFSRates(QuotingCalculation.CalcParam param){
        List<AfsRate> res = new List<AfsRate>();
        Map<String, List<AfsRate>> rate = getRates();
        system.debug('==> getAFSRates rate ' + rate);
        if(!rate.isEmpty()){
            system.debug('==> getAFSRates SHOOT NOT EMPTY ');
            if('Not Registered'.equalsIgnoreCase(param.gst)){
                res = rate.get('Used 7 years+');
            }else{
                res = rate.get(param.assetAge);
            }  
        }
        system.debug('==> res ' + res);
        return res;
    }
}