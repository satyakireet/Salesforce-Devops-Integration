@isTest
private class GithubCommunicationTest {   
    /*@isTest
    static void testGettingAllRepositories(){
        TestDataFactory td  = new TestDataFactory();
        Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.getAllRepoData()));
		Test.startTest();
        String d = GithubCommunication.getAllRepositories();
        Test.stopTest();
        System.assertEquals(TestDataFactory.getAllRepoData(), d);
    }*/
    
     @isTest
    static void testAllBranchesOfARepository(){
        TestDataFactory td  = new TestDataFactory();
        Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.getAllBranchesOfRepo()));
		Test.startTest();
        String d = GithubCommunication.getAllBranchesOfProjectRepo(td.project.Id);
        Test.stopTest();
        System.assertEquals(TestDataFactory.getAllBranchesOfRepo(), d);
    }
    
    /*@isTest
    static void testCreateBranch(){
        TestDataFactory td  = new TestDataFactory();
        Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.createBranchResponse()));
		Test.startTest();
        String d = GithubCommunication.createBranch('Test');
        Test.stopTest();
        System.assertEquals(TestDataFactory.createBranchResponse(), d);
    }*/
    
    /*@isTest
    static void testCreatePullRequestWithUserStory(){
        TestDataFactory td  = new TestDataFactory();
        Test.setMock(HttpCalloutMock.class, new HTTPMockGenerator(200, TestDataFactory.testCreatePullRequestByUserStory()));
		Test.startTest();
        String d = GithubCommunication.createPullRequest(td.userStory.id, 'Testing Branch Creation');
        Test.stopTest();
        System.assertEquals(TestDataFactory.testCreatePullRequestByUserStory(), d);
    }*/
    
}