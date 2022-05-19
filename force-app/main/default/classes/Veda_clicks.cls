global class Veda_clicks implements Schedulable {
   //public list<Opportunity_veda__c> kk = [select Idopvd__c, clicks__c from Opportunity_veda__c];
     global void execute(SchedulableContext SC) {
         for (Opportunity_veda__c mihw : [select Idopvd__c, clicks__c from Opportunity_veda__c]) {
             mihw.clicks__c=0;
             update mihw;
         }
             
      //  TestClass.test_protected_method();
       // TestClass.test_unrelated_method();
    }   

}