public class CompToolPlentiCalc extends CompToolLenderCalcAbstract {

  public CompToolPlentiCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.hasImports = 'N';
    
    // - Prepare parameters
    this.quoteParam.vehicleYear = String.valueOf(param.getAssetYear());
    this.quoteParam.customerProfile = 'Property Owner'.equals(param.residentialStatus) 
      ? 'Property Owner' : 'Non Property Owner';
    this.quoteParam.assetType  = param.assetType;
    this.quoteParam.clientTier = 'Property Owner'.equals(this.quoteParam.customerProfile) 
      ? 'Tier 1' : 'Tier 2';
    this.quoteParam.condition = param.assetAge == 0? 'new' : 'used';

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.clientTier = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);   
    
    this.quoteParam.amountBaseComm = param.getNetVehiclePrice();
    RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(this.quoteParam);
    if (rate != null) {
      this.quoteParam.commRate = rate.Overs__c;
    }

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.clientTier;

    // Custom Options
    r.customValue1 = this.quoteParam.clientTier;
    r.customLabel1 = 'Client Tier';
    r.customValue1Options = new List<String>{
      'Tier 1', 'Tier 2', 'Tier 3'
    };
    return r;
  }
  
}