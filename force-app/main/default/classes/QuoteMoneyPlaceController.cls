public without sharing class QuoteMoneyPlaceController {

    // @AuraEnabled
    // public static void save(String approvalType, QuoteController.AppQuotingWraper param){
    //     try {
    //         if (approvalType.equals('PRE-APPROVAL')) {
    //             savePdf(param);
    //         } else if (approvalType.equals('AMENDMENT')) {
    //             savePdf(param);
    //         } else if (approvalType.equals('FORMAL-APPROVAL')){
    //             savePdf(param);
    //         } else {
    //             savePdf(param);
    //         }
    //     } catch (Exception e) {
    //         throw new GenericException(e.getMessage());
    //     }
    // }
    
    @AuraEnabled
    public static String savePdf(QuoteController.AppQuotingWraper param, String approvalType){
        try {
            // pass parameters to the PDF page
            PageReference calcPdf = Page.UniversalCalculatorPdf;
            // pass universal variables
            calcPdf.getParameters().put('id',param.data.Opportunity__c);
            calcPdf.getParameters().put('lender', param.data.Name);
            // // calcPdf.getParameters().put('state', param.data.State__c);
            // // calcPdf.getParameters().put('vehicleGroup', qDto.vehicleGroup);
            // // calcPdf.getParameters().put('awd', qDto.awd);
            // // calcPdf.getParameters().put('turbo', qDto.turbo);
            // // calcPdf.getParameters().put('diesel', qDto.diesel);
            calcPdf.getParameters().put('mvLevel', null);
            calcPdf.getParameters().put('mv', String.valueOf(0.00));
            calcPdf.getParameters().put('mvIncome', String.valueOf(0.00));
            calcPdf.getParameters().put('gapLevel', null);
            calcPdf.getParameters().put('gap', String.valueOf(0.00));
            calcPdf.getParameters().put('gapIncome', String.valueOf(0.00));
            calcPdf.getParameters().put('taiLevel', null);
            calcPdf.getParameters().put('tai', String.valueOf(0.00));
            calcPdf.getParameters().put('taiIncome', String.valueOf(0.00));
            calcPdf.getParameters().put('ltiLevel', null);
            calcPdf.getParameters().put('lti', String.valueOf(0.00));
            calcPdf.getParameters().put('ltiIncome', String.valueOf(0.00));
            calcPdf.getParameters().put('warrantyLevel', null);
            calcPdf.getParameters().put('warranty', String.valueOf(0.00));
            calcPdf.getParameters().put('warrantyIncome', String.valueOf(0.00));
            calcPdf.getParameters().put('nwc', String.valueOf(0.00));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(0.00));
            // // if('A'.equals(dto.cciAcceptance)){
            // //     calcPdf.getParameters().put('cciLevel', dto.cciLevel);
            // //     calcPdf.getParameters().put('cci', String.valueOf(dto.cci));
            // //     calcPdf.getParameters().put('cciIncome', String.valueOf(dto.cciIncome));
            // // }else{
            // //     calcPdf.getParameters().put('cciLevel', null);
            // //     calcPdf.getParameters().put('cci', String.valueOf(0.00));
            // //     calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
            // // }
            // // //-
            calcPdf.getParameters().put('carPrice', param.data.Vehicle_Price__c+'');
            // // calcPdf.getParameters().put('deposit', param.data.deposit); 
            calcPdf.getParameters().put('applicationFee', param.data.Application_Fee__c+'');
            calcPdf.getParameters().put('dof', param.data.DOF__c+'');
            calcPdf.getParameters().put('ppsr', '0.00');
            calcPdf.getParameters().put('residualValue', param.data.Residual_Value__c+'');
            // // //calcPdf.getParameters().put('baseRate', param.data.baseRate);
            calcPdf.getParameters().put('baseRate', '----');
            calcPdf.getParameters().put('clientRate', param.data.Client_Rate__c+'');
            calcPdf.getParameters().put('term', param.data.Term__c+'');
            calcPdf.getParameters().put('paymentType', param.data.Payment__c+'');
            calcPdf.getParameters().put('estimatedCommission', param.data.Commission_Estimation__c+'');
            calcPdf.getParameters().put('insuranceIncome', param.data.Commission_Insurance_Income__c+'');
            calcPdf.getParameters().put('dofResult', param.data.Commission_DOF__c+'');
            calcPdf.getParameters().put('totalCommission', param.data.Commission_Total_GST_Exc__c+'');
            calcPdf.getParameters().put('totalCommissionGst', param.data.Commission_Total_GST_Inc__c+'');
            calcPdf.getParameters().put('naf', param.data.NAF__c+'');
            calcPdf.getParameters().put('rental', param.data.Rental__c+'');
            calcPdf.getParameters().put('monthlyFee', param.data.Monthly_Fee__c+'');
            calcPdf.getParameters().put('monthlyPayment', param.data.Repayment_Monthly__c+'');
            calcPdf.getParameters().put('fortnightlyPayment', param.data.Repayment_Fortnightly__c+'');
            calcPdf.getParameters().put('weeklyPayment', param.data.Repayment_Weekly__c+'');
            // //pass variables about the product info
            // calcPdf.getParameters().put('loanTypeDetail', qDto.loanTypeDetail);
            // calcPdf.getParameters().put('loanType', qDto.loanType);
            // calcPdf.getParameters().put('productLoanType', qDto.productLoanType);
            
            // calcPdf.getParameters().put('deposit', qDto.deposit);
            // calcPdf.getParameters().put('tradeIn', qDto.tradeIn);
            // calcPdf.getParameters().put('payoutOn', qDto.payoutOn);
            // calcPdf.getParameters().put('netDeposit', qDto.netDeposit);
            calcPdf.getParameters().put('loanPurpose',param.data.Loan_Purpose__c+'');
            
            // saving pdf in cloud?
            Boolean isSaveInCloud = false;
            if(approvalType.contains('APPROVAL')){
                isSaveInCloud = true;
                String typeData = 'Quoting Calculation';
                switch on approvalType {
                    when 'PRE_APPROVAL' {
                        typeData = 'Quoting Calculation (Amendment)';
                    }
                    when 'PRE_APPROVAL_AMENDMENT' {
                        typeData = 'Quoting Calculation (Formal Approval)';
                    }
                }
                ApplicationExtraDataHelper.upsertData(param.data.Id, typeData, typeData, QuotingToolHelper.getApplicationQuoting(param.data.Id));
            }
            // Opp.Id, prefixName --> lender
            QuotingToolHelper.attachPdfFile(param.data.Opportunity__c, param.data.Name, calcPdf, isSaveInCloud);
            return 'Success';
        }
        catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }
}