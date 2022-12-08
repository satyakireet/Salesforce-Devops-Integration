public class UserStoryTriggerHandler {
    
    @future(callout=true)
    public static void createFeatureBranch(String UserStories) {
        List<User_Story__c> uss = (List<User_Story__c>)JSON.deserialize(UserStories, List<User_Story__c>.class );
        List<User_Story__c> updatedUS = new List<User_Story__c>();
        for(User_Story__c userStory : uss) {
            String gitRepoId = [select Git_Repository__c from Project__c where Id =: userStory.Project__c].Git_Repository__c;
            Git_Repository__c repo = [
                SELECT Id, Name, Github_User_Name__c
                FROM Git_Repository__c where Id =: gitRepoId
            ];
            GithubCommunication.createBranch('Feature-'+userStory.Name, userStory.Id);
            userStory.Git_Branch_Url__c = 'https://github.com/'+repo.Github_User_Name__c+'/'+repo.Name+'/tree/Feature-'+userStory.Name;
            updatedUS.add(userStory);
        }
        update updatedUS;
    }
}