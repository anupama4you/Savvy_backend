@isTest(SeeAllData=true)
public with sharing class assetDetailsFormControllerTest {
    @isTest public static testMethod void testGetMakeSelectOptions(){
        // Get years
        Map<String,String> years = assetDetailsFormController.getYears('new');
        System.debug('Years for NEW >>', years.size());

        Map<String,String> years = assetDetailsFormController.getYears('demo');
        System.debug('Years for DEMO >>', years.size());

        Map<String,String> years = assetDetailsFormController.getYears('used');
        System.debug('Years for USED >>', years.size());

        // Get years with 2 parameters
        Map<String,String> years = assetDetailsFormController.getYears('new', 'Marine');
        System.debug('Years for NEW : Marine >>', years.size());

        Map<String,String> years = assetDetailsFormController.getYears('used', 'Marine');
        System.debug('Years for USED : Marine >>', years.size());

        Map<String,String> years = assetDetailsFormController.getYears('used', 'Motorcycle');
        System.debug('Years for USED : Motorcycle >>', years.size());

        // Make selections
        Map<String,String> makeSelect = assetDetailsFormController.getMakeSelectOptions('used','2015');
        System.debug('List of Makes for USED : 2015 >>', years.size());

        // Make selections (Redbook)
        Map<String,String> makeSelect = assetDetailsFormController.getMakeSelectOptionRedBook('2017');
        System.debug('List of Makes[Redbook] : 2017 >>', years.size());

        // Get Make models selections
        CarsWrapper wrapper = new CarsWrapper();
        wrapper.code = 'AUD';
        wrapper.newUsed = 'used';
        wrapper.year = '2018';
        wrapper.lender = 'AFS';
        wrapper.make = 'AUD';
        MakeModelDTO makeModel = assetDetailsFormController.getMakeModelsSelectOptions(wrapper);

        if(makeModel.glassObj != null){
            System.debug('Glass Object >>', makeModel.glassObj);
        }
        if(makeModel.glassObj != null){
            System.debug('Redbook Object >>', makeModel.redObj);
        }

        wrapper.lender = '';
        MakeModelDTO makeModel = assetDetailsFormController.getMakeModelsSelectOptions(wrapper);

        if(makeModel.glassObj != null){
            System.debug('Glass Object >>', makeModel.glassObj);
        }
        if(makeModel.glassObj != null){
            System.debug('Redbook Object >>', makeModel.redObj);
        }
        
    }

    @isTest public static testMethod void testGetMakeModelsSelectOptionsAux(){
        Map<String,String> makeModelAux = assetDetailsFormController.getMakeModelsSelectOptionsAux('AUD','used','2017');
        System.debug('Make Model Select Options : AUX >>', makeModelAux.size());

        Map<String,String> makeModelRedbook = assetDetailsFormController.getMakeModelsSelectOptionsRedbook('BMW','2017');
        System.debug('Make Model Select Options : Redbook >>', makeModelRedbook.size());

        String searchMakeRedbookCode = assetDetailsFormController.searchMakeRedbookCode('BMW','used','2017');
        System.debug('Search Make Redbook code >>', searchMakeRedbookCode);

        Map<String,String> modelVariantOptions = assetDetailsFormController.getModelVariantsSelectOptions('C06687', '2009');
        System.debug('Model Variant Select Options >>', modelVariantOptions.size());

        Map<String,String> modelVariantOptionsAux = assetDetailsFormController.getModelVariantsSelectOptionsAux('A1','2017','used');
        System.debug('Model Variant Aux Options >>', modelVariantOptionsAux.size());

        Map<String,String> variantSeriesOptionsAux = assetDetailsFormController.getVariantSeriesSelectOptionsAux('SPORTBACK 1.0 TFSI','A1','2017','AUD');
        System.debug('Variant series Aux Options >>', variantSeriesOptionsAux.size());

        Map<String,String> familyBatchSelectOptions = assetDetailsFormController.getFamilyBadgeSelectOptionsRedbook('CIVIC','HOND','2017');
        System.debug('Family Batch Select Options >>', familyBatchSelectOptions.size());

        Map<String,String> familyBatchSelectOptions2 = assetDetailsFormController.getFamilyBadgeSelectOptionsRedbook('CIVIC','HOND','2017','AFS');
        System.debug('Family Batch Select Options >>', familyBatchSelectOptions2.size());

        Map<String,String> badgeVariantSelectOptions = assetDetailsFormController.getBadgeVariantsSelectOptions('HOND','CIVIC','VTi');
        System.debug('Batch Variant Select Options >>', badgeVariantSelectOptions.size());

        Map<String,String> variantOptionsSelect = assetDetailsFormController.getVariantFactoryOptionsSelectOptions('AUDQ3-1T1514T622016A');
        System.debug('Variant Factory Select Options >>', variantOptionsSelect.size());
    }

    @isTest public static testMethod void testGetOptions(){
        List <Glass_Factory_Option__c> v = assetDetailsFormController.getVariantFactoryOptionsData('AUDQ3-1T1514T622016A');
        if (v != null)
            System.debug('Variant Factory Options Data >>', variantOptionsSelect.size());

        Map<String, Glass_Factory_Option__c> variantOptionsMapData = assetDetailsFormController.getVariantFactoryOptionsMapData('AUDQ3-1T1514T622016A');
        System.debug('Variant Options Map Data >>', variantOptionsMapData.size());

        v = assetDetailsFormController.getVariantStandardFactoryOptionsData('AUDQ3-1T1514T622016A');
        System.debug('Variant Standard Factory Options >>',  v.size());

        v = assetDetailsFormController.getVariantStandardFactoryOptionsData(null);
        System.debug('Variant Standard Factory Options >>',  v.size());

        Decimal variantNewPrice = assetDetailsFormController.getVariantNewPrice('AUDQ3-1T1514T622016A');
        System.debug('Variant New Price >>',  variantNewPrice);

        Glass_Variant__c variantByCode = assetDetailsFormController.getVariantByCode('AUDQ3-1T1514T622016A');
        System.debug('Variant By Code >>',  variantByCode);

        Glass_Make__c makeByCode = assetDetailsFormController.getMakeByCode('AUDQ3-1T1514T622016A');
        System.debug('Make By Code >>',  makeByCode);

        Glass_Model__c modelByCode = assetDetailsFormController.getModelByCode('AUDQ3-1T1514T622016A');
        System.debug('Model By Code >>',  modelByCode);

        Redbook_Family__c familyByCode = assetDetailsFormController.getFamilyByCode('AUDQ3-1T1514T622016A');
        System.debug('Family By Code >>',  familyByCode);

        Redbook_Vehicle__c vehicleByCode = assetDetailsFormController.getVehicleByCode('AUDQ3-1T1514T622016A');
        System.debug('Vehicle By Code >>',  vehicleByCode);

        RedbookVehicleDTO vehicleByRedbook = assetDetailsFormController.getVehicle('AUVHOND2017AEAE', null);
        System.debug('Vehicle By Redbook >>',  vehicleByRedbook);

        RedbookVehicleDTO vehicleByCode = assetDetailsFormController.getVehicle(null, 'AUVHOND2017AEAE');
        System.debug('Vehicle By Code >>',  vehicleByCode);

        RedbookVehicleDTO vehicleByCode = assetDetailsFormController.calculateAdjustment(null, 'AUVHOND2017AEAE');
        System.debug('Vehicle By Code >>',  vehicleByCode);

        Decimal num = assetDetailsFormController.calculateAdjustment('A', 70000, 50000);
        System.debug('calculate Adjustment #1 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('B', 70000, 50000);
        System.debug('calculate Adjustment #2 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('C', 70000, 50000);
        System.debug('calculate Adjustment #3 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('E', 70000, 50000);
        System.debug('calculate Adjustment #4 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('F', 70000, 50000);
        System.debug('calculate Adjustment #5 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('G', 70000, 50000);
        System.debug('calculate Adjustment #6 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('G', 150000, 50000);
        System.debug('calculate Adjustment #7 >>',  num);
        Decimal num = assetDetailsFormController.calculateAdjustment('G', 150001, 50000);
        System.debug('calculate Adjustment #8 >>',  num);

        assetDetailsFormController.loadTypeOptionsMap();

        Map<String, List<AssetOptionDTO>> variantOptionsByCode = assetDetailsFormController.getVariantOptionsByCode('AUDQ3-1T1514T622016A');
        System.debug('Variant Options by Code >>', variantOptionsByCode.size());

        List<AssetOptionDTO> variantOptionsByCodeNType = assetDetailsFormController.getVariantOptionsByCodeAndType('AUDQ3-1T1514T622016A', 'Standard');
        System.debug('Variant Options by Code & Type >>', variantOptionsByCodeNType.size());

        boolean redbookLenders = assetDetailsFormController.validateRedBookLenders('Pepper');
        System.debug('Validate Redbook Lenders >>', redbookLenders.size());
        
    }

    @isTest public static testMethod void testGetMakeModelsSelectOptionsAux(){
        GlassServicesHelper.Parameter p = new GlassServicesHelper.Parameter();
        p.year = '2017';
        p.make = 'AUD';
        p.family = 'A1';
        p.variant = 'SPORTBACK 1.0 TFSI';
        p.serie = '8X MY17';
        p.IdCar = 'AUDA1-SI1710UV02017A';
        Map<String,String> glassFamily = assetDetailsFormController.getGlassFamily(p);
        System.debug('Glass Family >>', glassFamily.size());

        Map<String,String> glassVariant = assetDetailsFormController.getGlassVariant(p);
        System.debug('Glass Variant >>', glassVariant.size());

        Map<String,String> glassSeries = assetDetailsFormController.getGlassSeries(p);
        System.debug('Glass Series >>', glassSeries.size());

        Integer glassCarsSize = assetDetailsFormController.getGlassCarsSize(p);
        System.debug('Glass Cars Size >>', glassCarsSize);

        List<Glass_Variant__c> glassCars = assetDetailsFormController.getGlassCars(p);
        System.debug('Glass Cars >>', glassCars);

        Double rRP = assetDetailsFormController.getRRP(p);
        System.debug('RRP >>', rRP);

        Glass_Variant__c glassCar = assetDetailsFormController.getGlassCar(p);
        System.debug('Glass Car >>', glassCar);

        Glass_Variant__c glassCarByCode = assetDetailsFormController.getGlassCarByCode(p);
        System.debug('Glass car by Code >>', glassCarByCode);

        Glass_Variant__c codeModel = assetDetailsFormController.getCodeModel(p);
        System.debug('Code Model >>', codeModel);

        CarListDTO carsList = assetDetailsFormController.getCarsList(p);
        System.debug('Cars List >>', carsList);

        VariantFactoryDTO variantFactoryOptions = assetDetailsFormController.getVariantFactoryOptions(p);
        System.debug('Variant Factory Options >>', variantFactoryOptions);

        Decimal calculatedUsedOptions = assetDetailsFormController.calculateUsedOptions(new List<String>{'AW19'}, '2018');
        System.debug('Calculated Used Options #1 >>', calculatedUsedOptions);
        Decimal calculatedUsedOptions = assetDetailsFormController.calculateUsedOptions(new List<String>{'AW19'}, '2010');
        System.debug('Calculated Used Options #2 >>', calculatedUsedOptions);
        Decimal calculatedUsedOptions = assetDetailsFormController.calculateUsedOptions(new List<String>(), '2010');
        System.debug('Calculated Used Options #3 >>', calculatedUsedOptions);

        Map<String, String>  streetTypeOptions = assetDetailsFormController.getStreetTypeOptions();
        System.debug('Street Type Options >>', streetTypeOptions.size());

        Map<String, String>  stateOptions = assetDetailsFormController.getStatesOptions();
        System.debug('States Options >>', stateOptions.size());

        Map<String, String>  stateOptions = assetDetailsFormController.getStatesOptions();
        System.debug('States Options >>', stateOptions.size());

        Application_Quoting__c applicationQuoting = assetDetailsFormController.getApplicationQuoting('a011y000002yBH1AAM','a0E1y000003WczGEAS');
        System.debug('Application Quoting >>', applicationQuoting);

    }
}
