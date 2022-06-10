public with sharing class assetDetailsFormController {
    public static Integer sizeCarsVD {set; get;}
    public static Map<String, Glass_Variant__c> recordGlassVariant {set; get;}
    private static Map<String, String> typeOptionsMap;
    private static List<String> redBookLenders = new List<String> {'Pepper', 'RateSetter'};

    @AuraEnabled(cacheable=true)
    public static Custom_Opportunity__c getCustomOpportunities(String recordId) {
        system.debug('::::: Id :::::' + recordId);
        List<Custom_Opportunity__c> li = [select Id, Name, Application__c, Purchase_Type__c, Dealer_Name__c, Dealer_Contact_Name__c, Dealer_Email__c, 
        Dealer_Phone_Number__c, Dealer_Mobile__c, Dealer_Unit_Number__c, Dealer_Street_Number__c, Dealer_Address__c,
         Dealer_Street_Type__c, Dealer_Suburb__c, Dealer_Postcode__c, Dealer_State__c , 
         Application_AssetDetail__r.Search_Certificate_Number__c, Application_AssetDetail__r.PPSR_Proxy_Message__c, 
         Application_AssetDetail__r.Actual_KM__c, Application_AssetDetail__r.Condition__c, Application_AssetDetail__r.Deposit__c, 
         Application_AssetDetail__r.Factory_Options__c, Application_AssetDetail__r.Fees__c, Application_AssetDetail__r.GAP__c,
          Application_AssetDetail__r.Lender__c, Application_AssetDetail__r.Type_Loan__c, Application_AssetDetail__r.LPI__c, 
          Application_AssetDetail__r.LTI__c, Application_AssetDetail__r.LVR__c, Application_AssetDetail__r.Make__c, 
          Application_AssetDetail__r.Model__c, Application_AssetDetail__r.NAF__c, Application_AssetDetail__r.Price__c,
           Application_AssetDetail__r.RRP__c, Application_AssetDetail__r.Series__c, Application_AssetDetail__r.Type__c, 
           Application_AssetDetail__r.Variant__c, Application_AssetDetail__r.Warranty__c, Application_AssetDetail__r.Year__c,
            Application_AssetDetail__r.Rego__c, Application_AssetDetail__r.VIN__c, Application_AssetDetail__r.Engine_No__c, 
            Application_AssetDetail__r.Colour__c, Application_AssetDetail__r.Rego_State__c,
             Application_AssetDetail__r.Redbook_Key__c, Application_AssetDetail__r.Variant_Desc__c,
              Application_AssetDetail__r.PPSR_Proxy_Id__c, Application_AssetDetail__r.PPSR_Proxy_Last_Update__c,  
              Owner_Email__c, Loan_Product__c, Contract_Number__c, Dealer_Type__c  from Custom_Opportunity__c
          WHERE Id = :recordId LIMIT 1];
        system.debug('::::: list :::::' + li);
        return li.get(0);
    }

    @AuraEnabled        
    public static Map<String,String> getPicklistValues(String objectAPIName, String fieldAPIName){
        Map<String,String> pickListValuesMap = new Map<String,String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get(fieldAPIName).getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            if(isFieldNotRequired)
                pickListValuesMap.put('--None--', '');
            if(pickListVal.isActive())
                pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        return pickListValuesMap;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getYears(String newUsed) {
        return getYears(newUsed.toLowerCase(), 'Car');
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getYears(String newUsed, String assetType) {
                                                                                                   
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getYears(newUsed, assetType);
      
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getMakeSelectOptions(String newUsed, String year){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getMakeSelectOptions(newUsed, year);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
            return r;
        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getMakeSelectOptionRedBook(String year){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getMakeSelectOptionRedBook(year);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // NEW METHOD
    @AuraEnabled
    public static MakeModelDTO getMakeModelsSelectOptions(CarsWrapper wrapper){
        try {
            
            system.debug('getMakeModelsSelectOptions:::'+ wrapper);

            // red 
            Map<String,String> rEd = new Map<String,String>();

            system.debug('xxxx:::'+ wrapper.lender);

            if(wrapper.lender != null){

                String makeRedbook  = GlassServicesHelper.searchMakeRedbookCode(wrapper.make, wrapper.newUsed, wrapper.year);
                List <SelectOption> familySelect;

                if(makeRedbook != null){

                    familySelect = GlassServicesHelper.getMakeModelsSelectOptionsRedbook(makeRedbook, wrapper.year);
                
                        for (SelectOption o : familySelect) {
                            rEd.put(o.getValue(), o.getLabel());
                            system.debug('xxxx:::'+ o.getValue()+ o.getLabel());
                        }
                }else{
                    familySelect = new List<SelectOption>();
                    familySelect.add(new SelectOption ('', '--No Models Found--')); 

                    for (SelectOption o : familySelect) {
                        rEd.put(o.getValue(), o.getLabel());
                        system.debug('xxxx:::'+ o.getValue()+ o.getLabel());
                    }
                }
    
            }

            system.debug('xxxx:::'+ rEd);

            // glass 
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getMakeModelsSelectOptionsAux(wrapper.make, wrapper.newUsed, wrapper.year);

            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }

            MakeModelDTO md = new MakeModelDTO();
            md.glassObj = r;
            md.redObj = rEd;

            return md;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getMakeModelsSelectOptionsAux(String code, String newUsed, String year){
        try {
            System.debug('parameters :::' + code + '|' + newused + '|' + year);
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getMakeModelsSelectOptionsAux(code, newUsed, year);
            
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
            

            a = GlassServicesHelper.getMakeModelsSelectOptionsRedbook(code, year);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }



            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getMakeModelsSelectOptionsRedbook(String code, String year){
        try {
            system.debug(code+ ':::::'+ year);
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getMakeModelsSelectOptionsRedbook(code, year);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string searchMakeRedbookCode(String code, String newUsed, String year){
        try {
            string s = GlassServicesHelper.searchMakeRedbookCode(code, newUsed, year);
            return s;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getModelVariantsSelectOptions(String code, String year){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getModelVariantsSelectOptions(code, year);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getModelVariantsSelectOptionsAux(String code, String year, String make){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getModelVariantsSelectOptionsAux(code, year, make);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getVariantSeriesSelectOptionsAux(String variantDesc, String model, String year, String make){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getVariantSeriesSelectOptionsAux(variantDesc, model, year, make);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getFamilyBadgeSelectOptionsRedbook(String code, String make, String year, String lender){
        try {
            Map<String,String> r = new Map<String,String>();
            Boolean status = validateRedBookLenders(lender);

            if(status){
                List <SelectOption> a = GlassServicesHelper.getFamilyBadgeSelectOptionsRedbook(code, make, year);
        
                for (SelectOption o : a) {
                    r.put(o.getValue(), o.getLabel());
                }
            }
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getBadgeVariantsSelectOptions(String makeRedbook, String model, String badge){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getFamilyBadgeSelectOptionsRedbook(makeRedbook, model, badge);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getVariantFactoryOptionsSelectOptions(String code){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getVariantFactoryOptionsSelectOptions(code);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List <Glass_Factory_Option__c> getVariantFactoryOptionsData(String code){
        try {
            return getVariantFactoryOptionsData(code, 'Optional');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List <Glass_Factory_Option__c> getVariantFactoryOptionsData(String code, String typeFeature){
        try {
            List <Glass_Factory_Option__c> li = GlassServicesHelper.getVariantFactoryOptionsData(code, typeFeature);
            return li;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Glass_Factory_Option__c> getVariantFactoryOptionsMapData(String code){
        try {
            Map<String, Glass_Factory_Option__c> mp = GlassServicesHelper.getVariantFactoryOptionsMapData(code);
            return mp;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Glass_Factory_Option__c> getVariantStandardFactoryOptionsData(String code) {
        try {
            if (String.isBlank(code)) {
                return null;
            }
            return getVariantFactoryOptionsData(code, 'Standard');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal getVariantNewPrice(String code){
        try {
            Decimal d = GlassServicesHelper.getVariantNewPrice(code);
            return d;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Glass_Variant__c getVariantByCode(String code) {
        try {
            Glass_Variant__c r = GlassServicesHelper.getVariantByCode(code); 
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Glass_Make__c getMakeByCode(String code) {
        try {
            Glass_Make__c r = GlassServicesHelper.getMakeByCode(code); 
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Glass_Model__c getModelByCode(String code) {
        try {
            Glass_Model__c r = GlassServicesHelper.getModelByCode(code);  
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Redbook_Family__c getFamilyByCode(String code){
        try {
            Redbook_Family__c r = GlassServicesHelper.getFamilyByCode(code); 
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Redbook_Vehicle__c getVehicleByCode(String code) {
        try {
            Redbook_Vehicle__c r = GlassServicesHelper.getVehicleByCode(code); 
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static RedbookVehicleDTO getVehicle(String redbookKey, String code){
        try {
            RedbookVehicleDTO rv = new RedbookVehicleDTO();

            if(!String.isBlank(redbookKey)){
                rv.vehicleByRedbookKey = GlassServicesHelper.getVehicleByRedbookKey(redbookKey);
            }else if(!String.isBlank(code)){
                rv.vehicleByCode = GlassServicesHelper.getVehicleByCode(code); 
            }

            return rv;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal calculateAdjustment(String category, Double kms, Double average) {
        try {
            Decimal d = GlassServicesHelper.calculateAdjustment(category, kms, average); 
            return d;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void loadTypeOptionsMap(){
        try {
            GlassServicesHelper.loadTypeOptionsMap();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, List<AssetOptionDTO>> getVariantOptionsByCode(String code) {
        try {
            Map<String, List<AssetOptionDTO>> r = GlassServicesHelper.getVariantOptionsByCode(code);
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AssetOptionDTO> getVariantOptionsByCodeAndType(String code, String typeOption) {
        try {
            List<AssetOptionDTO> r = GlassServicesHelper.getVariantOptionsByCodeAndType(code, typeOption);
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static boolean validateRedBookLenders(String lender){
        system.debug('lender:::'+ lender);
        try {
            boolean b = GlassServicesHelper.validateRedBookLenders(lender);
            system.debug('return:::'+ b);
            return b;
        } catch (Exception e) {
            system.debug('error:::'+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getGlassFamily(Parameter param) {
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getGlassFamily(param);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getGlassVariant(Parameter param) {
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getGlassVariant(param);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> getGlassSeries(Parameter param) {
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> a = GlassServicesHelper.getGlassSeries(param);
    
            for (SelectOption o : a) {
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void getGlassCarsList(Parameter param) {
        try {
            System.debug('>>>>>>>>>>>>>>>>>>>>   getGlassCarsList'+ param);
          
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getGlassCarsSize(Parameter param) {
        try {
            System.debug('>>>>>>>>>>>>>>>>>>>>   getGlassCarsSize'+ param);
            getGlassCars(param);
            return sizeCarsVD;
        } catch (Exception e) {
            System.debug('>>>>>>>>>>>>>>>>>>>>   getGlassCarsSize'+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Glass_Variant__c> getGlassCars(Parameter param) {
        try {
            List<Glass_Variant__c> r = GlassServicesHelper.getGlassCars(param);
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Double getRRP(Parameter param){
        try {
            Double d = GlassServicesHelper.getRRP(param);
            return d;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Glass_Variant__c getGlassCar(Parameter param) {
        try {
            Glass_Variant__c r = GlassServicesHelper.getGlassCar(param);
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static Glass_Variant__c getGlassCarAux(Parameter param) {
    //     try {
    //         Glass_Variant__c r = GlassServicesHelper.getGlassCarAux(param);
    //         return r;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static Glass_Variant__c getGlassCarByCode(Parameter param) {
        try {
            Glass_Variant__c g = GlassServicesHelper.getGlassCarByCode(param);
            return g;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getCodeModel(Parameter param) {
        try {
            String r = GlassServicesHelper.getCodeModel(param);
            return r; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // NEW METHOD 
    @AuraEnabled
    public static CarListDTO getCarsList(Parameter wrapper){
        try {

            system.debug('Get car list:::::'+ wrapper);

            Glass_Make__c glassMakeRec = GlassServicesHelper.getMakeByCode(wrapper.make);

            List<Glass_Variant__c> glassVariantObj = GlassServicesHelper.getGlassCars(wrapper);
            Glass_Variant__c glassVariant = GlassServicesHelper.getGlassCarAux(wrapper);

            CarListDTO cl = new CarListDTO();
            cl.glassMakeRec = glassMakeRec;
            cl.glassVariantObj = glassVariantObj;
            CL.glassVariant = glassVariant;

            return cl;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // NEW METHOD
    @AuraEnabled
    public static VariantFactoryDTO getVariantFactoryOptions(Parameter wrapper){
        system.debug('variantOptionsMap -- [parameters]::::'+ wrapper);
        try {
            Glass_Variant__c glassVariant = GlassServicesHelper.getGlassCarAux(wrapper);
            Map<String, List<AssetOptionDTO>> variantOptionsMap = new Map<String, List<AssetOptionDTO>>();
            Glass_Variant__c variantObj; 
            string model;
            VariantOptionsSettingDTO assetStandardFeautersData;

            if(glassVariant != null){
                variantOptionsMap =  GlassServicesHelper.getVariantOptionsByCode(glassVariant.Code__c);
                system.debug('variantOptionsMap::::'+ variantOptionsMap);

                if(variantOptionsMap != null){
                     assetStandardFeautersData = loadVariantOptionsSettings(variantOptionsMap);
                }

                variantObj = GlassServicesHelper.getVariantByCode(glassVariant.Code__c);
                model = GlassServicesHelper.getCodeModel(wrapper);
                system.debug('variantOptionsMap::::'+ model);
            }
            
            VariantFactoryDTO vf = new VariantFactoryDTO();
            vf.glassVariant = glassVariant;
            vf.variantOptionsMap = variantOptionsMap;
            vf.variantObj = variantObj;
            vf.model = model;
            vf.assetStandardFeautersData = assetStandardFeautersData;

            system.debug('glassVariant::::'+ glassVariant);
            system.debug('variantOptionsMap::::'+ variantOptionsMap);
            system.debug('variantObj::::'+ variantObj);
            system.debug('model::::'+ model);
            system.debug('assetStandardFeautersData::::'+ assetStandardFeautersData);

            system.debug('VF::::'+ vf);
            return vf;
            
        } catch (Exception e) {
            system.debug('getVariantFactoryOptions - ERROR::::'+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static VariantOptionsSettingDTO loadVariantOptionsSettings(Map<String, List<AssetOptionDTO>> variantOptionsMap){
        system.debug('loadVariantOptionsSettings:::');
        try {
            MAP<String, List<AssetOptionDTO>> assetOptionsData = new Map<String, List<AssetOptionDTO>>();
            // List <SelectOption> assetOptionsSelect = new List<SelectOption>();
            Map<String, String> assetOptionsSelect = new Map<String, String>();
            List<AssetOptionDTO> d = variantOptionsMap.get('Optional');
            if (d != null) {
                for (AssetOptionDTO a : d) {
                    system.debug('xxxxxxxx::::'+ a);
                    
                    List<AssetOptionDTO> tmp = assetOptionsData.get(a.code);
                    if (tmp == null) {
                        tmp = new List<AssetOptionDTO>();
                        assetOptionsData.put(a.code, tmp);
                    }
                    tmp.add(a);

                    // // assetOptionsSelect.add(new SelectOption(a.code, (a.name + ' ($' + a.value.format() + ')')));
                    assetOptionsSelect.put(a.code, (a.name + ' ($' + a.value.format() + ')'));
                    /// assetOptionsData.put(a.code, a);
                }
            }
            List <AssetOptionDTO> assetStandardFeautersData = variantOptionsMap.get('Standard');   
            
            VariantOptionsSettingDTO vo = new VariantOptionsSettingDTO();
            vo.assetOptionsData = assetOptionsData;
            vo.assetOptionsSelect = assetOptionsSelect;
            vo.assetStandardFeautersData = assetStandardFeautersData;

            return vo;

        } catch (Exception e) {
            system.debug('loadVariantOptionsSettings - ERROR::::'+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal calculateUsedOptions(List<String> options, String year) {
        try {
            Decimal d = GlassServicesHelper.calculateUsedOptions(options, year);
            return d;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, String>  getStreetTypeOptions(){
        try {
            Map<String,String> r = new Map<String,String>();
            List<SelectOption> stOptions = UtilitiesList.getStreetTypeOptions();

            for (SelectOption o : stOptions) {
                if(o.getValue() == ''){
                    continue;
                }
                r.put(o.getValue(), o.getLabel());
            }
    
            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, String> getStatesOptions(){
        try {
            Map<String,String> r = new Map<String,String>();
            List <SelectOption> statesOfIssue2Sel = UtilitiesList.getStatesOptions();
            
            for (SelectOption o : statesOfIssue2Sel) {
                r.put(o.getValue(), o.getLabel());
            }

            return r;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
}
