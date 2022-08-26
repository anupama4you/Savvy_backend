public without sharing class QuoteGreenLightController {
  
  public class lenderSettingsWrapper {
    @AuraEnabled 
    public Decimal applicationFee {set;get;} 
    @AuraEnabled
    public Decimal dof {set;get;}
    
  }
  
  //This method will use to load data in green light form  
  @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'GreenLightRates__c';

        Map<String, List<GreenLightRates__c>> rates = new Map<String, List<GreenLightRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
  }

  //This method will use to return data record to green light table rates
  public static List<GreenLightRates__c> getRates() {
      List<GreenLightRates__c> r = new List<GreenLightRates__c>();
      List<GreenLightRates__c> rates = GreenLightRates__c.getAll().values();
      r.sort();
      for (GreenLightRates__c g: rates) {
        if (String.isBlank(g.LVR__C)) {
          r.add(g);
        }
      }
      return r;
  }

  //this method will calculate fees (application fee, max app fee, dof, max dof)
  @AuraEnabled
  public static Map<String, Decimal> getFees(QuotingCalculation.CalcParam param, lenderSettingsWrapper lenderSettings, Boolean onlyMax) {
      Decimal resAF = 0.00;
      Decimal resMAF = 0.00;
      Decimal resDOF = 0.00;
      Decimal resMDOF = 0.00;
      Decimal b = getNafValidation(QuotingCalculation.CALC_QUOTING, param, false);
      resMAF = b * 0.1;
      resMDOF = b * .08;
      if (resMAF == 0 || resMAF > lenderSettings.applicationFee) {
        resMAF = lenderSettings.applicationFee;
      }
      if ( resMDOF == 0 ||  resMDOF > lenderSettings.dof) {
        resMDOF = lenderSettings.dof;
      }
      if (!onlyMax) { 
        resAF = resMAF;
        resDOF = resMDOF;
      }

      return new Map<String, Decimal>{'applicationFee' => resAF,
                                      'maxApplicationFee' => resMAF,
                                      'dof' => resDOF,
                                      'maxDof' => resMDOF
                                    };
  }

  public static Decimal getNafValidation(String calcType, QuotingCalculation.CalcParam param, Boolean excludeInsurances) {
    Decimal r = 0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        if (param.vehiclePrice != null) r += param.vehiclePrice + (param.vehiclePrice * QuotingCalculation.getProtectedPercentaje(param.vehiclePrice));
    } else {
        if (param.vehiclePrice != null) r += param.vehiclePrice;
        System.debug('==> inside else before '+ r);
    }
    System.debug('==> r before minus '+ r);
    r-= param.netDeposit;
    System.debug('==> r before exclude'+ r);
    if (excludeInsurances) {
      r += param.totalInsurance;
      System.debug('==> r inside exclude '+ r);
    }
    return r;
  }

  @AuraEnabled
  public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param, Boolean resetBrokerage) {
    Decimal br = 0.00;
    Decimal max = 0.00;
    Decimal bp = param.brokeragePer;
    Decimal cr = param.clientRate;
      //get base rate
      br = QuotingCalculation.getBaseRate(param);
      if (param.hasMaxRate != null && param.hasMaxRate) {
        //get max rate
        max = QuotingCalculation.getMaximunBaseRate(param);
      }
      
      //get client rate
      if (br == max) {
        cr = br;
      } else if (cr > max) {
        cr = max;
      }
    
      //get brokerage percentage
      GreenLightRates__c g = QuotingCalculation.getRateGreenLight(param);
      if(g != null){
        if (
          param.brokeragePer == null || 
          param.brokeragePer > g.Brokerage_Max__c ||
          resetBrokerage
        ) {
          bp = g.Brokerage_Max__c;
        }
      }
 
    return new Map<String, Decimal>{'baseRate' => br, 
                                    'maxRate' => max,
                                    'brokeragePer' => bp,
                                    'clientRate' => cr
                                  };

  }

  @AuraEnabled
  public static List<GreenLightRates__c> getGreenlight(QuotingCalculation.CalcParam param) {
    List<GreenLightRates__c> results = new List<GreenLightRates__c>();
    GreenLightRates__c gl = QuotingCalculation.getRateGreenLight(param);
    if(gl != null){
      results.Add(gl);
    }
    return results;
  }

  @AuraEnabled
  public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
    param.amountBaseComm = getNafValidation(QuotingCalculation.CALC_QUOTING, param, true);
    System.debug('==> calculateRepayments param '+ param);
    return QuoteController.calculateRepayments(param);
  }
  
}