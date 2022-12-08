public class InternalController {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> allProjects() {
        return [select Id, Name from Project__c];
    }
    
    @AuraEnabled
    public static String getUserStoryProject(String userStoryId) {
        return [select Project__r.Id from User_Story__c where Id =: userStoryId].Project__r.Id;
  		
    }
    
    @AuraEnabled
    public static List<PathWrapper> getUserStoryPath(String userStoryId) {
        List<String> path = new List<String>();
        User_Story__c userStory = [select Name, Project__r.Pipeline__r.Id, Source__r.Name, Initial_Org__c, Initial_Org__r.Name from User_Story__c where Id =: userStoryId];
        path.add(userStory.Initial_Org__r.Name);
        
        Boolean flag = true;
        String sourceId = userStory.Initial_Org__r.Id;
        while(flag) {
            try {
                Pipeline_Connection__c connection = [select Id, Source_Environment__c, Destination_Environment__c, Destination_Environment__r.Name from Pipeline_Connection__c where Pipeline__c =: userStory.Project__r.Pipeline__r.Id AND Source_Environment__c =: sourceId][0];
        		path.add(connection.Destination_Environment__r.Name);
                sourceId = connection.Destination_Environment__c;
            }catch(Exception ex) {
                flag = false;
            }
        }
        Boolean pflag = false;
        system.debug('Path : '+path);
        List<PathWrapper> pathW = new List<PathWrapper>();
        for(String p : path) {
            if(p == userStory.Source__r.Name) {
                pathW.add(new PathWrapper(p,'slds-path__item slds-is-active slds-is-current'));
                pflag = true;
            }else if(pflag) {
                pathW.add(new PathWrapper(p,'slds-path__item slds-is-incomplete'));
            }else {
                pathW.add(new PathWrapper(p,'slds-path__item slds-is-complete'));
            }
        }
        return pathW;
    }
    
    @AuraEnabled
    public static String[] getSourceAndTargetBranchNames(String userStoryId){
        List<String> branches = new List<String>();
        User_Story__c us = [select Name, Source__c, Ready_to_Promote__c, Project__r.Pipeline__r.Id from User_Story__c where Id =: userStoryId]; 
        if(us.Ready_to_Promote__c) {
            Pipeline_Connection__c connection = [select Id, Source_Environment__c, Destination_Environment__c, Destination_Environment__r.Name from Pipeline_Connection__c where Pipeline__c =: us.Project__r.Pipeline__r.Id AND Source_Environment__c =: us.Source__c][0];
            branches.add([select Branch__c from Git_Branch__c where Org__c =: connection.Destination_Environment__c].Branch__c);
            branches.add([select Branch__c from Git_Branch__c where Org__c =: us.Source__c].Branch__c);
            branches.add('Create Promotion');
        } else {
            branches.add([select Branch__c from Git_Branch__c where Org__c =: us.Source__c].Branch__c);
        	branches.add('Feature-'+us.Name);
            branches.add('Don\'t Create Promotion');
        }
        return branches;
    }
    
    @AuraEnabled
    public static Promotion__c createPromotion(String userStoryId, String sourceBranch, String targetBranch, Integer pullNumber) {
        Promotion__c promo = new Promotion__c();
        promo.User_Story__c = userStoryId;
        promo.Source_Org__c = [select Org__c from Git_Branch__c where Branch__c =: sourceBranch].Org__c;
        promo.Target_Org__c = [select Org__c from Git_Branch__c where Branch__c =: targetBranch].Org__c;
        promo.Status__c = 'Pending Approval';
        promo.Attached_Pull_Request_Number__c = pullNumber;
        insert promo;
        
        User_Story__c us = new User_Story__c();
        us.Id = userStoryId;
        us.Last_Promotion__c = promo.Id;
        update us;
        return promo;
    }
    
    @AuraEnabled
    public static Boolean checkCodeCoverage(String userStoryId) {
        User_Story__c userStory = [select has_Apex_Code__c, Apex_Code_Coverage__c, Minimum_Apex_Code_Coverage__c from User_Story__c where Id =: userStoryId];
        if(userStory.has_Apex_Code__c) {
			if(userStory.Apex_Code_Coverage__c >= userStory.Minimum_Apex_Code_Coverage__c) {
                return true;
            }            
        }else {
            return true;
        }
        return false;
    }
    public static MetadataService.MetadataPort createService()
        {
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            return service;
        }

        public static void createRemoteSiteSettings()
        {   
            MetadataService.MetadataPort service = createService();
            MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
            remoteSiteSettings.fullName = 'Test12345';
            remoteSiteSettings.url = 'http://www.google.com';
            remoteSiteSettings.description= 'ewf' ;
            remoteSiteSettings.isActive=true;
            remoteSiteSettings.disableProtocolSecurity=false;
            MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
            MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
            system.debug('chk' + checkResults );
        }
        
    public class PathWrapper {
        @AuraEnabled
        public String stageName{get;set;}
        @AuraEnabled
        public String className{get;set;}
        public PathWrapper() {}
        public PathWrapper(String stageN,String classN) {
            this.stageName = stageN;
            this.className = classN;
        }
    }  













}