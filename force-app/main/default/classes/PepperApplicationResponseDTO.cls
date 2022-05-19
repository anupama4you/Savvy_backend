public class PepperApplicationResponseDTO extends ObjectJsonSerialize{
    
    public String errorCode {set; get;}
    public String errorMessage {set; get;}
    public String requestId {set; get;}
    public String lastResponseApplication {set; get;}
    public Application application {set; get;}
    public List<LenderAPIResponse__c> docs {get; set;}
    
    public class Application {
        public String applicationNo {set; get;}
    }
}