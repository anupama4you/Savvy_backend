public without sharing class QuoteAffordableCLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        String rateObjName1 = param.rateSettings.get(0);
        String rateObjName2 = param.rateSettings.get(1);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName1, getListInterestRate(param.calcName));
        rates.put(rateObjName2, getACLUpfrontLoanFees());
        r.rateSettings = rates;
        r.settings = QuotingCalculation.getLenderSettings(ACLCalculatorExtension.LENDER_QUOTING);
        return r;
    }

    public static List<BasicLenderRates__c>  getListInterestRate(String LENDER_QUOTING){
        return QuotingCalculation.listBasicRates(LENDER_QUOTING);
    }

    public static List<ACLUpfrontLoanFees__c> getACLUpfrontLoanFees() {
        List<ACLUpfrontLoanFees__c> d = ACLUpfrontLoanFees__c.getall().values();
        d.sort();
        return d;
    }

    // public static calcRiskFee(Decimal myRate) {
    //     Decimal riskFeeTotal = 0;
    //     if (myRate == null || myRate == 0.0) {
    //         myRate = this.maxRate;
    //     }
    //     List <ACLUpfrontLoanFees__c> aclUpfrontLoanFees = [
    //         Select Min_Interest_Rate__c, Max_Interest_Rate__c, Establishment_Fee__c, 
    //             Risk_Fee_Interest_Rate_Of_NAF__c, Max_Lend__c, Comm__c
    //         From ACLUpfrontLoanFees__c
    //         Order by Min_Interest_Rate__c DESC
    //     ];
    //     if (aclUpfrontLoanFees != null && !aclUpfrontLoanFees.isEmpty()) {
    //         System.debug('Assigning fees... [' + myRate + ']');
    //         ACLUpfrontLoanFees__c x = QuotingCalculation.getAffordableFees(myRate);
    //         if (x != null) {
    //             if (x.Establishment_Fee__c > 0 && x.Establishment_Fee__c != this.maxApplicationFee) {
    //                 this.maxApplicationFee = x.Establishment_Fee__c;
    //                 System.debug('App fee: ' + this.applicationFee);
    //                 if (this.applicationFee == null || this.applicationFee == 0) {
    //                 this.applicationFee = this.maxApplicationFee;
    //                 }
    //             }
    //             riskFeeTotal = ((myRate/100 * x.Risk_Fee_Interest_Rate_Of_NAF__c/100) * getLoandTermInYears() * getNAF()).setScale(2);
    //         }
    //     }
    // }

    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
        try {
            QuoteController.saveQuoting(param);
            Product__c p = null;
            if (!'NONE'.equals(approvalType)) {
                // save pdf
                PageReference pdf = Page.UniversalCalculatorPdf;
                pdf = pdfHandler(param.data);
                QuoteController.savePdf(approvalType, pdf, param);
                // save product
                p = productHandler(param.data);
                QuoteController.saveProduct(param, p);
            }
        }
        catch (Exception ex) {
        throw new GenericException(ex.getMessage());
        }
        return param.data;
    }

    // Lee - 18/07/2022
    public static PageReference pdfHandler(Application_Quoting__c quote){

        // pass parameters to the PDF page
        PageReference pdf = Page.UniversalCalculatorPdf;
        
        // pass universal variables
        pdf.getParameters().put('id',quote.Opportunity__c);
        pdf.getParameters().put('lender', quote.Name);

        //Financial Details
        pdf.getParameters().put('loanType',  quote.Loan_Type__c+'');
        pdf.getParameters().put('loanProduct', quote.Loan_Product__c+'');
        pdf.getParameters().put('price', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
        pdf.getParameters().put('ppsr',  NumberUtils.format(quote.PPSR__c));
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
        pdf.getParameters().put('term', quote.Term__c+'');
        pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
        pdf.getParameters().put('profile', quote.Customer_Profile__c+'');
        pdf.getParameters().put('vehicleYear', quote.Vehicle_Age__c+'');
        pdf.getParameters().put('lvr', String.valueOf(quote.LTV__c)+'');
        pdf.getParameters().put('paymentType', quote.Payment__c+'');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c+'');
        pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
        
        // ---- commissions -----
        pdf.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
        pdf.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));
        pdf.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
        pdf.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
        pdf.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
        pdf.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
        pdf.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
        pdf.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
        pdf.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
        pdf.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
        // ---- end commissions -----

        return pdf;
    }

    @AuraEnabled
    // Lee - 18/07/2022
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use': 'Business Use';
        p.Lender__c = ACLCalculatorExtension.LENDER_QUOTING;
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Term__c = quote.Term__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00; 
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;

        return p;
    }
}