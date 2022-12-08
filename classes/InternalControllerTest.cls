@isTest
public class InternalControllerTest {
	@isTest
    public static void test(){
        TestDataFactory tdf = new TestDataFactory();
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.createBranchResponse()));
        	InternalController.getSourceAndTargetBranchNames(tdf.userStory.Id);
        	Boolean result = InternalController.checkCodeCoverage(tdf.userStory.Id);
        	system.assertEquals(false, result);
        Test.stopTest();
    }
    
    @isTest
    public static void testCoverage(){
        TestDataFactory tdf = new TestDataFactory();
        tdf.updateUserStoryCodeCoverage();
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.createBranchResponse()));
        	Boolean result = InternalController.checkCodeCoverage(tdf.userStory.Id);
        	system.assertEquals(true, result);
        Test.stopTest();
    }
}