@isTest
public class RunApexTestsControllerTest {
    
    @isTest
    public static void testApexTestCodeCoverage(){
        TestDataFactory tdf = new TestDataFactory();
        List<MetadataWrapper> mData = tdf.getMetadataWrapperElements();
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200,TestDataFactory.getJSONValueForCodeCoverage()));
        	RunApexTestsController.getCodeCoverageOfClasses(mData);
        Test.stopTest();
    }
    
    @isTest
    public static void testApexTestCodeCoverageOfUserStory(){
        TestDataFactory tdf = new TestDataFactory();
        List<MetadataWrapper> mData = tdf.getMetadataWrapperElements();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200,TestDataFactory.getJSONValueForCodeCoverage()));	
            RunApexTestsController.getCodeCoverage(mData,tdf.userStory.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testApexTestWrapperConstructorWithNoParameter(){
        RunApexTestsController.ApexTestWrapper atw = new RunApexTestsController.ApexTestWrapper();
        System.assertEquals(null, atw.name);
        System.assertEquals(null, atw.type);
        System.assertEquals(null, atw.coverage);
        System.assertEquals(null, atw.isTestClassWritten);
    }
}