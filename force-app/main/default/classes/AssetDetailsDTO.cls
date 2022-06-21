public with sharing class AssetDetailsDTO {
    @AuraEnabled
    public Glass_Variant__c variantObj {get;set;}
    @AuraEnabled
    public String modelTypeSource {get;set;}
    @AuraEnabled
    public String model {get;set;}
    @AuraEnabled
    public String make {get;set;}
    @AuraEnabled
    public String options {get;set;}
    @AuraEnabled
    public String newUsed {get;set;}
    @AuraEnabled
    public List <Glass_Factory_Option__c> assetStandardFeautersData {get;set;}
    @AuraEnabled
    public List <AssetOptionDTO> assetStandardFeautersData2 {get;set;}
    @AuraEnabled
    public Decimal totalPriceOptions {get;set;}
    @AuraEnabled
    public Decimal totalTradeLowPriceOptions {get;set;}
    @AuraEnabled
    public Decimal totalTradePriceOptions {get;set;}
    @AuraEnabled
    public Decimal totalRetailPriceOptions {get;set;}
    //LTV
    @AuraEnabled
    public String lender {get;set;}
    @AuraEnabled
    public String typeLoan {get;set;}
    @AuraEnabled
    public String carPrice {get;set;}
    @AuraEnabled
	public String deposit {get;set;}
    @AuraEnabled   
    public String warranty {get;set;}   
    @AuraEnabled
    public String gap {get;set;}   
    @AuraEnabled
    public String lpi {get;set;}   
    @AuraEnabled
    public String lti {get;set;}
    //Calculated
    @AuraEnabled
    public String carAge {get;set;}
    @AuraEnabled
    public String fees {get;set;}
    @AuraEnabled
    public String realFees {get;set;}
    @AuraEnabled
    public String ltvLabel {get;set;}
    @AuraEnabled
    public String ltvValue {get;set;}
    @AuraEnabled
    public String naf {get;set;}
    @AuraEnabled
    public String lvrLabel {get;set;}
    @AuraEnabled
    public String lvrValue {get;set;}
    @AuraEnabled
    public Integer actualKms {get;set;}
    @AuraEnabled
    public Decimal totalTradeLowPriceKms {get;set;}
    @AuraEnabled
    public Decimal totalTradePriceKms {get;set;}
    @AuraEnabled
    public Decimal totalRetailPriceKms {get;set;}
    @AuraEnabled
    public String purchaseType {get;set;}
    @AuraEnabled
    public String contractNumber {get; set;}
    //Others vehicles
     @AuraEnabled
    public String assetType {get;set;}
     @AuraEnabled
    public String makeOVehicle {get;set;}
     @AuraEnabled
    public String modelOVehicle {get;set;}
     @AuraEnabled
    public String variantOVehicle {get;set;}
     @AuraEnabled
    public String seriesOVehicle {get;set;}
     @AuraEnabled
    public String year {get;set;}
    //Vendor Details
     @AuraEnabled
    public String vendorName {get;set;}
     @AuraEnabled
    public String vendorEmail {get;set;}
     @AuraEnabled
    public String vendorAddress {get;set;}
     @AuraEnabled
    public String vendorContact {get;set;}
     @AuraEnabled
    public String vendorPhone {get;set;}
     @AuraEnabled
    public String vendorMobile {get;set;}
    
     @AuraEnabled
    public String rego {get;set;}
     @AuraEnabled
    public String vin {get;set;}
     @AuraEnabled
    public String engine {get;set;}
     @AuraEnabled
    public String colour {get;set;}
     @AuraEnabled
    public String regoState {get;set;}
     @AuraEnabled
    public String redbookKey {get;set;}

    public AssetDetailsDTO() {
        totalPriceOptions = 0;
        totalTradeLowPriceOptions = 0;
        totalTradePriceOptions = 0;
        totalRetailPriceOptions = 0;
        totalTradeLowPriceKms = 0;
        totalTradePriceKms = 0;
        totalRetailPriceKms = 0;
    }
    
    public Decimal getNewPriceValue() {
        if (variantObj != null) {
        	return (variantObj.New_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getTradeLowGlassValue() {
        if (variantObj != null) {
        	return (variantObj.Trade_Low_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getTradeGlassValue() {
        if (variantObj != null) {
        	return (variantObj.Trade_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getRetailGlassValue() {
        if (variantObj != null) {
        	return (variantObj.Retail_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getNewPriceAdjustedValue() {
        if (variantObj != null && variantObj.New_Price__c != null) {
        	return (variantObj.New_Price__c + getDefaultValue(totalPriceOptions));
        }
        return 0.0;
    }
    
    public Decimal getTradeLowAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Low_Price__c != null) {
        	return (variantObj.Trade_Low_Price__c + getDefaultValue(totalTradeLowPriceOptions) + getDefaultValue(totalTradeLowPriceKms));
        }
        return 0.0;
    }
    
    public Decimal getTradeAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Price__c != null) {
        	return (variantObj.Trade_Price__c + getDefaultValue(totalTradePriceOptions) + getDefaultValue(totalTradePriceKms));
        }
        return 0.0;
    }
    
    public Decimal getReatilAdjustedValue() {
        if (variantObj != null && variantObj.Retail_Price__c != null) {
        	return (variantObj.Retail_Price__c + getDefaultValue(totalRetailPriceOptions) + getDefaultValue(totalRetailPriceKms));
        }
        return 0.0;
    }
    
    public Double getAverageKmValue() {
        Double r = null;
        if (variantObj != null && variantObj.Average_Kms__c != null) {
            r = variantObj.Average_Kms__c * 1000;
        }
        return r;
    }
    
    private Decimal getDefaultValue(Decimal value) {
        if (value == null) {
            return 0.0;
        }
        return value;
    }
    
    public String getCarLabel() {
        String label = 'Car';
        if (!'Car'.equalsIgnoreCase(assetType)) {
            label = 'Vehicle';
        }
        return label;
    }
}