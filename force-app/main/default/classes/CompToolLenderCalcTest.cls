@IsTest(SeeAllData=true)
public class CompToolLenderCalcTest {
  
  public static List<String> residencyValues = new List<String>{
    'Property Owner', 'Renting', 'Boarding'
  };

  public static List<String> creditHistoryValues = new List<String>{
    'Good', 'Credit Issues'
  };

  public static List<String> assetTypeValues = new List<String>{
    'Car', 'Motorbike', 'Boat', 'Caravan', 'Truck', 'Personal'
  };

  @IsTest
  static void calculateAfsCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('AFS Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10, 20, 30, 40
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Types
    List<String> assetTypes = new List<String>{
      'Car', 'Motorbike', 'Boat', 'Caravan'
    };
    for (String assetType : assetTypes) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAfsConsumer() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('AFS Consumer');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10, 20, 30, 40
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Types
    List<String> assetTypes = new List<String>{
      'Car', 'Motorbike', 'Boat', 'Caravan'
    };
    for (String assetType : assetTypes) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAmmf() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('AMMF');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10
    };
    p.residentialStatus = residencyValues.get(1);
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAnzCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('ANZ Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAnzOthers() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('ANZ Others');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateBoq() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('BOQ');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateBoqComm() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('BOQ Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateFinanceOne() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Finance One');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateFinanceOneComm() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Finance One Commercial');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateFirstmac() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Firstmac');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10
    };
    p.residentialStatus = residencyValues.get(1);
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateGreenLight() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Green Light');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateLatitude() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Latitude');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }

    // Badcredit
    p.assetType = 'Caravan';
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateLatitudePL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Latitude PL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }

    // Badcredit
    p.assetType = 'Caravan';
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateLiberty() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Liberty');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit history
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }  

  @IsTest
  static void calculateLibertyCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Liberty Commercial');
    // Residency
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    Test.stopTest();
  }

  @IsTest
  static void calculateLibertyLeisure() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Liberty Leisure');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit history
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculateMacquarieCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Macquarie Commercial');
    // Asset Types
    for (String a : assetTypeValues) {
      p.assetType = a;
      ComparisonToolsController.calculate(c, p);
    }
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMacquarieConsumer() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Macquarie Consumer');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMetro() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Metro');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMoney3() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Money3');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateMoneyPlace() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Money Place');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateNowFinance() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Now Finance');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePepperCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper Commercial');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Truck';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperLeisure() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper Leisure');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperMV() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper MV');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper PL');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePlenti() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Plenti');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePlentiCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Plenti Commercial');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePlentiPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Plenti PL');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateWisrVL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Wisr VL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }

    // Commission rate
    p.term = 36;
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculateWisrPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Wisr PL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }

    // Commission rate
    p.term = 36;
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  private static Calculator__c getCalculator(String name) {
    return new Calculator__c(Name = name);
  }

  public static CompToolLenderCalcAbstract.FilterParams buildFilterParameter() {
    CompToolLenderCalcAbstract.FilterParams f = new CompToolLenderCalcAbstract.FilterParams();
    f.price = 20000;
    return f;
  }

}