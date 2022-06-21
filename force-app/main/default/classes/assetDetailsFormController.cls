public with sharing class assetDetailsFormController {
    public static Integer sizeCarsVD {set; get;}
    public static Map<String, Glass_Variant__c> recordGlassVariant {set; get;}
    private static Map<String, String> typeOptionsMap;
    private static List<String> redBookLenders = new List<String> {'Pepper', 'RateSetter'};

    @AuraEnabled(cacheable=true)
    public static Custom_Opportunity__c getCustomOpportunities(String recordId) {
        system.debug('::::: Id :::::' + recordId);
        List<Custom_Opportunity__c> li = [select Id, Name, Application__c, Purchase_Type__c, 
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
            Loan_Product__c, 
            Contract_Number__c, 
            Account__c,
            Account_Amount_1__c,
            Account_Amount_2__c,
            account_bsb_1__c,
            account_bsb_2__c,
            Account_Email__c,
            Account_First_Name__c,
            Account_Last_Name__c,
            Account_Name_1__c,
            Account_Name_2__c,
            Account_Number_1__c,
            Account_Number_2__c,
            Account_Reference_1__c,
            Address__c,
            All_Documents_Attached__c,
            Applicant_Net_Income__c,
            Application_AssetDetail__c,
            ApplicationServicing__c,
            ApplicationYTD__c,
            Approval_conditions_checked__c,
            ASIC_Registration__c,
            Asset_Make__c,
            Borrower_Contact__c,
            Capacity_Symbol__c,
            Client_Budget__c,
            Cloned__c,
            Co_Borrower_Net_Income__c,
            Confirm_Settled__c,
            Count_Opp__c,
            CreatedById,
            Credit_Card_Payments__c,
            Credit_History__c,
            Credit_Repair_Notification__c,
            Current_payslip_symbol__c,
            Current_payslip_with_vehicle_allowance__c,
            Date_Closed_or_Settled__c,
            Date_Last_Call_Activity__c,
            Date_of_Birth__c,
            Date_Pre_Approved__c,
            Date_Send_To_Aspect__c,
            Date_Settled__c,
            Dealer_Account_Email__c,
            Dealer_Contact_Name__c,
            Dealer_Contacted__c,
            Dealer_Email__c,
            Dealer_Fax_Number__c,
            Dealer_Mobile__c,
            Dealer_Address__c,
            Dealer_Name__c,
            Dealer_Phone_Number__c,
            Dealer_Postcode__c,
            Dealer_State__c,
            Dealer_Street_Number__c,
            Dealer_Street_Type__c,
            Dealer_Suburb__c,
            Dealer_Type__c,
            Dealer_Unit_Number__c,
            Docs_not_fraudulent_amended__c,
            Document_Count__c,
            Email_Address__c,
            emailoptout__c,
            Employer_ABN_arm_s_length__c,
            Employer_letter_confirming_business_use__c,
            Employer_letter_symbol__c,
            Employment_Status__c,
            End_of_Loan_Date__c,
            eSignLive_Date__c,
            eSignLive_Text_Box__c,
            Establishment_Fee__c,
            Existing_Loan_Payments__c,
            Finance_Amount__c,
            Finance_Product__c,
            Finance_Product_Not_Offered_Symbol__c,
            Finance_Product_Offered_Symbol__c,
            Financier__c,
            First_Name__c,
            Flag_Is_Note_for_Amendment_Created__c,
            Flag_Is_Note_for_Formal_Approval_Created__c,
            Flag_Is_Note_for_Pre_Approval_Created__c,
            FolderId__c,
            Franchise_Owner__c,
            Goods_Description__c,
            Goods_Type__c,
            Google_the_employer_to_match_app__c,
            Home_Phone__c,
            Insurance_Cover__c,
            Insurance_Products_with_null_Policy_Amt__c,
            International_Number__c,
            Is_Sent_to_Aspect__c,
            Is_Trade_In__c,
            Is_Vendor_Company__c,
            Is_your_client_a_Property_Owner__c,
            LastModifiedById,
            Last_Name__c,
            Last_Submission_Date__c,
            Lead__c,
            Lead_Consultant__c,
            Lead_Consultant_Dealer__c,
            Lead_Email_Address__c,
            Lead_Finance_Amount__c,
            Lead_Loan_Type__c,
            Lender_Approved__c,
            Pre_Approved_Vehicle_Age__c,
            Length_of_Term__c,
            Letter_from_Accountant__c,
            Letter_from_Accountant_symbol__c,
            Living_Expenses__c,
            Loan_Term_Process__c,
            Low_Doc_confirmation__c,
            Low_Doc_confirmation_symbol__c,
            Mobile_Number__c,
            Monthly_Surplus__c,
            Mortgage_Rent__c,
            NAF_Net_Amount_Financed__c,
            NAP_Net_Amount_Policy__c,
            New_Used_Final__c,
            New_Used__c,
            No_Capacity_Symbol__c,
            No_hardship_for_applicant__c,
            No_hardship_for_applicant_symbol__c,
            Notes__c,
            Notes_to_Settlement_Officer__c,
            NPS__c,
            NPS_Reason__c,
            Number_FullComp_Ins_Sales__c,
            Number_Insurance_Sales__c,
            Number_of_Dependents__c,
            Number_Other_Ins_Sales__c,
            Occupation__c,
            Occupation_Status__c,
            Occupation_Time_Months__c,
            Occupation_Time_Years__c,
            Opp_Asset_Type__c,
            Opp_Client_Rate__c,
            Opp_Cost_of_Goods__c,
            Opp_Loan_Term__c,
            Opp_Loan_Type__c,
            Opp_Product_Lender__c,
            Other_Expenses__c,
            Other_Fees_or_Charges__c,
            Other_Income__c,
            Other_Income_Detail__c,
            Owner__c,
            OwnerId,
            Owner_Email__c,
            Owner_First_Name__c,
            Owner_Mobile__c,
            Owner_Name__c,
            Owner_Phone__c,
            Owner_ProfileID__c,
            OwnerType__c,
            Partner_BS_Service__c,
            Partner_Business_Name__c,
            Partner_Client_Portal__c,
            Partner_ForApproval_Type__c,
            Partner_Is_External__c,
            Partner_Owner__c,
            Partner_PreApproval_Type__c,
            Payout_Details__c,
            Payslip_shows_YTD_figure__c,
            Personal_references_loaded__c,
            Preapproval_Auth_Date__c,
            Pre_Approved_Amount__c,
            Pre_Approved_Date__c,
            Pre_Quoting_Object__c,
            Preferred_Lender__c,
            Product_Count__c,
            Property_Owner__c,
            Reason_for_Closure__c,
            Recent_BAS_symbol__c,
            Recent_Business_Activity_Statement__c,
            Recent_Tax_Return_symbol__c,
            Recent_Tax_Return_with_M_V_deductions__c,
            Record_Owner_Email__c,
            RecordTypeId,
            Related_Documents__c,
            Repayment_Per_Week__c,
            Req_doc_Settled_status__c,
            Required_Client_Deposit__c,
            Second_Applicant_Added_Later__c,
            Second_Applicant_Email__c,
            Second_Applicant_First_Name__c,
            Second_Applicant_Last_Name__c,
            Secondary_form_of_income__c,
            Sent_for_Settlement_Date__c,
            SentToLenderNotified__c,
            Service_Rating__c,
            Service_Review__c,
            Settled_and_Mortgaged__c,
            Settled_Email_Rules__c,
            Settled_five_years__c,
            Settled_four_years__c,
            Settled_seven_years__c,
            Settled_six_years__c,
            Settled_three_years__c,
            Settlement_Officer_Notes__c,
            Signed_Deed_of_Novation__c,
            Signed_Deed_symbol__c,
            smsoptout__c,
            Special_Conditions__c,
            Split_Expenses__c,
            State__c,
            Status__c,
            Tax_Invoice_Amount__c,
            Tax_Invoice_Deposit__c,
            Tax_Invoice_Deposit_2__c,
            Tax_Invoice_GST__c,
            Tax_Invoice_Total__c,
            Tax_Invoice_Total_no__c,
            This_Commitment__c,
            Today__c,
            Total_Brokerage__c,
            Total_Brokerage_DOF_exc_GST__c,
            Total_Commission__c,
            Total_DOF__c,
            Total_Existing_Expenses__c,
            Total_Expenses__c,
            Total_Income__c,
            Total_Insurance_Commission__c,
            Trade_in_Details__c,
            User_Email_Signature__c,
            VD_Commission_Ex_GST__c,
            VD_Date_Sent__c,
            VD_Date_Settled__c,
            VD_Is_Old_Process__c,
            VD_Notes__c,
            VD_Owner__c,
            VD_Worksheet__c,
            VD_Reason_for_closure__c,
            VD_Status__c,
            VD_Status_Process__c,
            Vehicle_Color__c,
            Vehicle_Details__c,
            Vehicle_ID__c,
            Vehicle_Make__c,
            Vehicle_Model__c,
            Vehicle_Registration__c,
            Vehicle_securities_registration_fee__c,
            Vehicle_Year__c,
            Vendor_ABN__c,
            Vendor_and_purchaser_arm_s_length__c,
            Vendor_Name_2__c,
            VerifiedFields__c,
            Work_Phone__c 
            from Custom_Opportunity__c
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
        System.debug('getCodeModel::');
        System.debug('parameter::'+param);
        try {
            String r = GlassServicesHelper.getCodeModel(param);
            System.debug('output::'+r);
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
            System.debug('calculateUsedOptions:::'+ options+ year);
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

    @AuraEnabled
    public static Application_Quoting__c getApplicationQuoting(Id oppId, Id appId){
        try {
            Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(oppId, appId);
            return d;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static String insertAssetDetails(Application_Asset_Detail__c appAssetDetails, Custom_Opportunity__c oppt, AssetDetailsDTO dto,  String prefixFile){
        try {
            System.debug('insert >> asset details:::'+ appAssetDetails);
                if(appAssetDetails.Id == null){
                    insert appAssetDetails;
                    System.debug('inserted >>>'+appAssetDetails);
                    oppt.Application_AssetDetail__c = appAssetDetails.Id;
                }else{
                    update appAssetDetails;
                    System.debug('updated >>>'+appAssetDetails);
                }
                
                if(appAssetDetails.LVR__c != null){
                    QuotingToolHelper.updateLTV(oppt.Id, String.valueOf(appAssetDetails.LVR__c));
                    System.debug('updateLTV >>>'+appAssetDetails.LVR__c);
                }
                System.debug('update oppt:::'+ oppt);
                System.debug('DTO:::'+ dto);

                // oppt.New_Used__c = dto.newUsed.capitalize();
                System.debug('update oppt:::'+ oppt);
                update oppt;
                System.debug('update oppt:::'+ oppt);

                String prefixName = 'AssetDetails_' + prefixFile;
                String typeData = null;
                Boolean isSaveCloud = false;

                if (prefixFile.equals('PRE_APPROVAL_')) {
                    typeData = 'Asset Detail - LTV (Pre-approval)';
                } else if (prefixFile.equals('FORMAL_APPROVAL_')) {
                    typeData = 'Asset Detail - LTV (Formal Approval)';
                    isSaveCloud = true;
                    // if(!Test.isRunningTest()) {
                    //     if(this.Opp.Id != null){
                    //         System.enqueueJob(new queueActiveDealerTagCallout(Opp)); 
                    //     }
                    // }
                } else if (prefixFile.equals('AMENDMENT_')) {
                    typeData = 'Asset Detail - LTV (Amendment)';
                    isSaveCloud = true;
                }
                if (typeData != null) {
                    System.debug('Application__c:::'+ oppt.Application__c);
                    System.debug('Name:::'+ dto.lender);
                    System.debug('typeData:::'+ typeData);
                    System.debug('dto:::'+ dto);
                    ApplicationExtraDataHelper.upsertData(oppt.Application__c, 'Asset Detail ' + dto.lender, typeData, dto);
                }
                return 'success';

        } catch (Exception e) {
            return e.getMessage();
            // throw new AuraHandledException(e.getMessage());
        }
    }
 
    @AuraEnabled
    public static Boolean isUserIdSettlementTeam(Id userId){
        try {
            System.debug('isUserIdSettlementTeam:::'+ userId );
            return ApprovalTools.isUserIdSettlementTeam(userId);
        } catch (Exception e) {
            return false;
            // throw new AuraHandledException(e.getMessage());
        }
    }
   
}
