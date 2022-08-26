public without sharing class QuoteFinanceOneCommController {

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
            for (FinanceOneRates__c fors: rates) {
                if('Commercial'.equalsIgnoreCase(fors.Category__c)){
                    res.add(fors);
                }
            }
        }
        return res;
    }

    //return goods sub type options
    @AuraEnabled
    public static Map<String,List<QuoteWrapper.Picklist>> getGoodsSubTypes(List<String> goodTypes){
        try {
            Map<String,List<QuoteWrapper.Picklist>> res = new Map<String,List<QuoteWrapper.Picklist>>();
            List<QuoteWrapper.Picklist> motorVehiclePL = new List<QuoteWrapper.Picklist>();
            List<QuoteWrapper.Picklist> motorBikeVehiclePL = new List<QuoteWrapper.Picklist>();
            List<QuoteWrapper.Picklist> watercraftPL = new List<QuoteWrapper.Picklist>();
            List<QuoteWrapper.Picklist> recreationalAssetPL = new List<QuoteWrapper.Picklist>();
            QuoteWrapper.Picklist pickValOpt = new QuoteWrapper.Picklist();
            for(Product_Goods_Subtypes__c pgs: [SELECT Description__c, Type__c, Value__c FROM Product_Goods_Subtypes__c WHERE Type__c IN: goodTypes]){
                pickValOpt = new QuoteWrapper.Picklist();
                if('Motor Vehicle'.equalsIgnoreCase(pgs.Type__c)){
                    pickValOpt.label = pgs.Description__c;
                    pickValOpt.value = pgs.Value__c;
                    motorVehiclePL.add(pickValOpt);   
                }else if('Motorbike'.equalsIgnoreCase(pgs.Type__c)){
                    pickValOpt.label = pgs.Description__c;
                    pickValOpt.value = pgs.Value__c;
                    motorBikeVehiclePL.add(pickValOpt); 
                }else if('Watercraft'.equalsIgnoreCase(pgs.Type__c)){
                    pickValOpt.label = pgs.Description__c;
                    pickValOpt.value = pgs.Value__c;
                    watercraftPL.add(pickValOpt); 
                }else if('Recreational Asset'.equalsIgnoreCase(pgs.Type__c)){
                    pickValOpt.label = pgs.Description__c;
                    pickValOpt.value = pgs.Value__c;
                    recreationalAssetPL.add(pickValOpt); 
                }
            }

            if(!motorVehiclePL.isEmpty()){
                res.put('Car', motorVehiclePL);
            }
            if(!motorBikeVehiclePL.isEmpty()){
                res.put('Motorbike', motorBikeVehiclePL);
            }
            if(!watercraftPL.isEmpty()){
                res.put('Boat', watercraftPL);
            }
            if(!recreationalAssetPL.isEmpty()){
                res.put('Caravan', recreationalAssetPL);
            }
            return res;
        }
        catch (Exception e) {
          throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
        Decimal br = 0.00;
        Decimal max = 0.00;
        Decimal cr = 0.00;
        //Decimal bp = param.brokeragePer;
        //Decimal cr = param.clientRate;
        //get base rate
        br = QuotingCalculation.getBaseRate(param);
        if (param.hasMaxRate != null && param.hasMaxRate) {
            //get max rate
            max = QuotingCalculation.getMaximunBaseRate(param);
        }

        cr = br;
        if(param.brokeragePer > 4){
            cr = br + param.brokeragePer - 4;
        }
        return new Map<String, Decimal>{'baseRate' => br, 
                                        'maxRate' => max,
                                        'clientRate' => cr
                                    };

    }

    public static Decimal getNafCommission(QuotingCalculation.CalcParam param, String calcType) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (param.vehiclePrice != null) r += param.vehiclePrice + (param.vehiclePrice * QuotingCalculation.getProtectedPercentaje(param.vehiclePrice));
        } else {
            if (param.vehiclePrice != null) r += param.vehiclePrice;
        }
        if (param.netDeposit != null) r -= param.netDeposit;
        
        return r;
    }

    @AuraEnabled
    public static Decimal getCommission(QuotingCalculation.CalcParam param) {
        return param.brokeragePer / 100 * getNafCommission(param, QuotingCalculation.CALC_QUOTING) * 1.1;
    }
    
    ////Return Calc Risk Fee Calculations
    @AuraEnabled
    public static Decimal getRiskFeeCalc(QuotingCalculation.CalcParam param) {
        Decimal r = 0.0;
        Decimal nc = getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        nc += getCommission(param);
        if ('Silver'.equals(param.loanTypeDetail)) {
          if ((nc + 995.0) <= 12000) {
            r = 995.0;
          } else if ((nc + 1495.00) > 12000 && (nc + 1495.00) <= 20000) {
            r = 1495.00;
          } else if ((nc + 1495.00) > 20000) {
            r = 1995.00;
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
        
            if (totalAmount >= 8000 && totalAmount <= 14000) {
              r = (totalAmount * 0.10).setScale(2);
                
              if(r > 990){
                r = 990.00;
              }
            } else if (totalAmount > 14000) {
                r = 1100.00;
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

    //Return Finance One Rate
    @AuraEnabled
    public static List<FinanceOneRates__c> getFinanceOneRate (QuotingCalculation.CalcParam param){
        return new List<FinanceOneRates__c>{QuotingCalculation.getFinanceOneRates(param)};
    }
    
    //Finance One Commercial Calculate Button Logic
    @AuraEnabled
    public static Application_Quoting_Result__c calculateRepayments (QuotingCalculation.CalcParam param){
        param.nafCommission = getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        return QuoteController.calculateRepayments(param);
    }

    //return aaplication fee calculation
    @AuraEnabled
    public static Decimal getApplicationFeeCalc (QuotingCalculation.CalcParam param){
        param.totalAmount = getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        return QuotingCalculation.getFinanceOneApplicationFee(param);
    }
}