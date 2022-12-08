@isTest
public class RetrieveMetadataTest {
	@isTest
    public static void test() {
        Test.startTest();
            RetrieveMetadata.getAllMetadata();
        	RetrieveMetadata.getNonTestApexClasses();
            RetrieveMetadata.getTestApexClasses();
            RetrieveMetadata.getApexTriggers(10);
        Test.stopTest();
    }
}