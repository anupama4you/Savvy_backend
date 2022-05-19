@isTest
public class ComparisonToolsControllerTest {
  
  @isTest
  static void case1() {
    ComparisonToolsController.compare(
      buildFilterParameter()
    );
  }

  public static ComparisonToolsController.FilterParams buildFilterParameter() {
    ComparisonToolsController.FilterParams f = new ComparisonToolsController.FilterParams();
    return f;
  }

}