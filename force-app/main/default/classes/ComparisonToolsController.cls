public without sharing class ComparisonToolsController {

  @AuraEnabled
  public static List<Calculator__c> compare(FilterParams filter) {
    return new List<Calculator__c>();
  }

  //Inner classes
  public class FilterParams {
    public String assetType { get; set; }
    public String loanType { get; set; }
    public String employmentType { get; set; }
    public String purchaseType { get; set; }
    // public String termEnd {set;get;}
    public String creditHistory { get; set; }
    public String residentialStatus { get; set; }

    public String assetCondition { get; set; }
    public Integer assetAge { get; set; }
    public Integer loanTerm { get; set; }
    public Decimal price { get; set; }
    public Decimal deposit { get; set; }
    public Decimal residual { get; set; }

    // public String sortBy {set;get;}
    // public Boolean recalculating {set;get;}
    // public Decimal targetCommission {set;get;}
    // public Decimal estimateCommission {set;get;}
    // public Decimal dofValue {set;get;}

    //Brokerage %
    // public Decimal rateValue {set;get;}

    // Lelo                 2018-05-29
    public String hasPayday { get; set; }
    public String hasVerifiableCredit { get; set; }
    public Integer jobsLast3Years { get; set; }
    public String hasEnquiries { get; set; }
    public Integer creditScore { get; set; }
    public String verifiableSavings { get; set; }
    public String ltv { get; set; }

    // Lelo                 2018-05-29
    // public Integer applicantAge {set;get;}
    // public Decimal annualIncome {set;get;}
    // public String tier {set;get;}
    // public String riskGrade {set; get;}
    // public String customerProfile {set; get;}

    public FilterParams() {
      //Temp
      this.assetType = 'Car';
      this.loanType = 'Consumer Loan';
      this.employmentType = 'Full-Time';
      this.purchaseType = 'Dealer';
      this.creditHistory = 'Clean History';
      this.residentialStatus = 'Property Owner';
      //
      this.assetCondition = 'New';
      this.assetAge = null;
      this.loanTerm = 60;
      this.price = null;
      this.deposit = null;
      this.residual = null;

      this.ltv = '90-99';
      this.creditScore = 750;
      this.jobsLast3Years = 0;
    }

    public String getPrivateSales() {
      String r = 'N';
      if ('Private'.equals(purchaseType)) {
        r = 'Y';
      }
      return r;
    }

    public Decimal getNetVehiclePrice() {
      Decimal r = 0.0;
      if (this.price != null) {
        r = this.price;
      }
      if (this.deposit != null) {
        r -= this.deposit;
      }
      return r;
    }
  }
}