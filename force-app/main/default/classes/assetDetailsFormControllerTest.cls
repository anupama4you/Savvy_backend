@isTest(SeeAllData=true)
public with sharing class assetDetailsFormControllerTest {
    public static testMethod void testGetMakeSelectOptions(){
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

    public static testMethod void testGetMakeModelsSelectOptionsAux(){
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
        
    }
}
