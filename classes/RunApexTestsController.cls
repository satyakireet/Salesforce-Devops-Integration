public with sharing class RunApexTestsController {
    
    @AuraEnabled
    public static String runTests(String[] testClasses) {
        ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
        for(String className : testClasses) {
            ApexClass apexClass = [select Id from ApexClass where Name =: className];
            queueItems.add(new ApexTestQueueItem(ApexClassId=apexClass.Id));
        }
        insert queueItems;
        return 'Success'; 
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ApexTestWrapper> getCodeCoverageOfClasses(List<MetadataWrapper> classes) {
        ToolingAPI toolingApi;
        
        List<ApexTestWrapper> apexTests = new List<ApexTestWrapper>();
        for(MetadataWrapper cls : classes) {
            toolingApi = new ToolingAPI();
            Boolean isTest = true;
            String query = 'Select ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered From ApexCodeCoverageAggregate Where ApexClassOrTrigger.Name = \''+cls.name+'\'';
        	List<ToolingAPI.ApexCodeCoverageAggregate> codeCoverage = (List<ToolingAPI.ApexCodeCoverageAggregate>) toolingApi.query(query).records;
            system.debug('Res - '+codeCoverage);
            Decimal coverage = countPercentCodeCoverage(codeCoverage[0].NumLinesCovered, codeCoverage[0].NumLinesUncovered);
            if((Integer)codeCoverage[0].NumLinesCovered == 0) { isTest = false; }
            apexTests.add(new ApexTestWrapper(cls.Name,cls.type,coverage.setScale(0)+'%',isTest));
        }
        return apexTests;
    }
    
    @AuraEnabled
    public static List<ApexTestWrapper> getCodeCoverage(List<MetadataWrapper> classes, String userStory) {
        ToolingAPI toolingApi;
        Integer countClassWithoutCoverage = 0;
        Integer countTriggerWithoutCoverage = 0;
        Integer totalCoverage = 0;
        
        List<ApexTestWrapper> apexTests = new List<ApexTestWrapper>();
        for(MetadataWrapper cls : classes) {
            toolingApi = new ToolingAPI();
            Boolean isTest = true;
            String query = 'Select ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered From ApexCodeCoverageAggregate Where ApexClassOrTrigger.Name = \''+cls.name+'\'';
        	List<ToolingAPI.ApexCodeCoverageAggregate> codeCoverage = (List<ToolingAPI.ApexCodeCoverageAggregate>) toolingApi.query(query).records;
            Decimal coverage = countPercentCodeCoverage(codeCoverage[0].NumLinesCovered, codeCoverage[0].NumLinesUncovered);
            if((Integer)codeCoverage[0].NumLinesCovered == 0) { isTest = false; }
            if(cls.type == 'Apex Class' && coverage == 0) { countClassWithoutCoverage++; }
            if(cls.type == 'Apex Trigger' && coverage == 0) { countTriggerWithoutCoverage++; }
            totalCoverage = totalCoverage + (Integer)coverage.setScale(0);
            apexTests.add(new ApexTestWrapper(cls.Name,cls.type,coverage.setScale(0)+'%',isTest));
        }
        saveCodeCoverage(userStory, apexTests.size(), totalCoverage, countClassWithoutCoverage, countTriggerWithoutCoverage);
        return apexTests;
    }
    
    private static void saveCodeCoverage(String userStory,Integer count, Integer totalCoverage, Integer countClassWithoutCoverage, Integer countTriggerWithoutCoverage) {
        User_Story__c userS = new User_Story__c();
        userS.Id = userStory;
        userS.Apex_Code_Coverage__c = totalCoverage/count;
        userS.Classes_Without_Coverage__c = countClassWithoutCoverage;
        userS.Triggers_Without_Coverage__c = countTriggerWithoutCoverage;
        update userS;
    }
    
    private static Decimal countPercentCodeCoverage(Integer covered,Integer uncovered) {
        Integer total = (covered + uncovered);
        Decimal coverage = (Decimal)covered / total; 
        return coverage*100;
    }
    
    public class ApexTestWrapper {
        @AuraEnabled
    	public String name{get;set;}
        @AuraEnabled
    	public String type{get;set;}
        @AuraEnabled
    	public String coverage{get;set;}
        @AuraEnabled
    	public Boolean isTestClassWritten{get;set;}
        
        public ApexTestWrapper(){}
        
        public ApexTestWrapper(String name, String type, String cov, Boolean testClass){
            this.name = name;
            this.type = type;
            this.coverage = cov;
            this.isTestClassWritten = testClass;
        }
    }
    
    
}