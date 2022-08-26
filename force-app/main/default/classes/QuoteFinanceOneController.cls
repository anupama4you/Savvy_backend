public without sharing class QuoteFinanceOneController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'FinanceOneRates__c';

        Map<String, List<FinanceOneRates__c>> rates = new Map<String, List<FinanceOneRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    public static List<FinanceOneRates__c> getRates() {
        List<FinanceOneRates__c> res = new List<FinanceOneRates__c>();
        List<FinanceOneRates__c> rates = FinanceOneRates__c.getAll().values();
        if(rates != NULL && !rates.isEmpty()){
            rates.sort();
            for (FinanceOneRates__c fors: rates) {
                if(!'Commercial'.equalsIgnoreCase(fors.Category__c)){
                    res.add(fors);
                }
            }
        }
        return res;
    }

    ////Return Calc Risk Fee Calculations
    @AuraEnabled
    public static Decimal getRiskFeeCalc(QuotingCalculation.CalcParam param) {
        Decimal r = 0.0;
        Decimal nc = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        nc += param.totalInsurance;
        if (param.dof != null){
            nc+= param.dof;
        }

        if (String.isBlank(param.loanTypeDetail) || param.loanTypeDetail == 'Economy') {
            r = 0;
        } else if ('Consumer Loan'.equals(param.productLoanType) && 
                   ('Gold'.equals(param.loanTypeDetail) || 'Platinum'.equals(param.loanTypeDetail))) {
          r = 995.0;
        } else {
            if ((nc + 995.0) >= 5000 && (nc + 995.0) <= 12000) {
                r = 995.0;
            } else if ((nc + 1495.00) > 12000 && (nc + 1495.00) <= 20000) {
                r = 1495.00;
            } else if ((nc + 1495.00) > 20000) {
                r = 1995.00;
            } else {
                r = 0;
            }
        }
        return r.setScale(2);
    }

    //Return DOF and Max DOF Calculations
    @AuraEnabled
    public static Map<String, Decimal> getDofCalcu (QuotingCalculation.CalcParam param, Boolean fullCalc) {
        Decimal totalInsurance = param.totalInsurance;
        Decimal totalAmount = 0;
        Decimal dof = 0.0;
        Decimal maxDof = 0.0;
        if (param.vehiclePrice != null) totalAmount += param.vehiclePrice;
        totalAmount = totalAmount - param.netDeposit + totalInsurance;
        Decimal r = 0.0;
        
            if (param.loanTypeDetail == 'Economy') {
                r = 550.0;
                if (totalAmount >= 6000 && totalAmount < 7000) {
                    r = 660.0;
                } else if (totalAmount >= 7000 && totalAmount < 8000) {
                    r = 770.0;
                } else if (totalAmount >= 8000) {
                    r = 880.0;
                }
            } else {
                if (totalAmount >= 5000 && totalAmount <= 14000) {
                    r = 990.00;
                } else if (totalAmount > 14000) {
                    r = 1100.00;
                }
            }
        if (fullCalc){
            dof = r;
        } 
        maxDof = r;
        //System.debug(this.loanTypeDetail + '|' + totalAmount.format() + '|' + r.format() + '|max:' + this.maxDof + '|dof:' + this.dof);
        return new Map<String, Decimal>{'dof' => dof, 
                                        'maxDof' => maxDof
                                    };
    } 

     //Finance One Calculate Button Logic
     @AuraEnabled
     public static Application_Quoting_Result__c calculateRepayments (QuotingCalculation.CalcParam param){
         param.nafCommission = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
         return QuoteController.calculateRepayments(param);
     }
}