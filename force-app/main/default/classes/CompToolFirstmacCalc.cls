public class CompToolFirstmacCalc extends CompToolLenderCalcAbstract {

  public CompToolFirstmacCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.customerProfile = 'Standard';
    this.quoteParam.interestType = 'Fixed';
    
    // - Prepare parameters
    this.quoteParam.residency = 
      'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    
    if ('Y'.equals(this.quoteParam.residency) && this.param.assetAge == 0) {
      this.quoteParam.loanTypeDetail = 'New / Demo';
    } else if (this.param.assetAge <= 3) {
      this.quoteParam.loanTypeDetail = 'Used < 3 years';
    } else if (this.param.assetAge <= 5) {
      this.quoteParam.loanTypeDetail = 'Used 4-5 years';
    } else if (this.param.assetAge <= 7) {
      this.quoteParam.loanTypeDetail = 'Used 6-7 years';
    } else {
      this.quoteParam.loanTypeDetail = 'Used 8-12 years';
    }
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.interestType = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Interest Type: ' + this.quoteParam.interestType;

    // Custom Options
    r.customValue1 = this.quoteParam.interestType;
    r.customLabel1 = 'Interest Type';
    r.customValue1Options = new List<String>{
      'Variable', 'Fixed'
    };
    return r;
  }
  
}