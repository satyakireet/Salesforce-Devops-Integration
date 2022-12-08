@isTest
public class LwcChartControllerTest {
	@isTest
    public static void test() {
        TestDataFactory tdf = new TestDataFactory();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.createBranchResponse()));
        tdf.createProjectWithSprints();
        LwcChartController.getProjectSprints(tdf.project.Id);
        Test.stopTest();
    }
}