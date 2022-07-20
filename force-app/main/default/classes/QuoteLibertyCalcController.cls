public with sharing class QuoteLibertyCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        return r;
    }

    // @AuraEnabled
    // public static Decimal getProtectedPercentaje(QuoteController.QuotingDataParam param) {
    //   return QuotingCalculation.getProtectedPercentaje(param);
    // }
}
