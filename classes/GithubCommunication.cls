public with sharing class GithubCommunication {
    //can remove
    /*private static void githubDetails() {
        Git_Repository__c repo = [
            SELECT id, Name, GitHub_Access_Token__c, Github_User_Name__c
            FROM Git_Repository__c
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        TOKEN = repo.GitHub_Access_Token__c;
        USER = repo.Github_User_Name__c;
        REPOSITORY = repo.Name;
        return;
    }*/
    
    private static void projectGithubDetails(String projectId) {
        String gitRepoId = [select Git_Repository__c from Project__c where Id =: projectId].Git_Repository__c;
        Git_Repository__c repo = [
            SELECT id, Name, GitHub_Access_Token__c, Github_User_Name__c
            FROM Git_Repository__c where Id =: gitRepoId
        ];
        TOKEN = repo.GitHub_Access_Token__c;
        USER = repo.Github_User_Name__c;
        REPOSITORY = repo.Name;
        return;
    }
    
    private static String TOKEN;
    private static String USER;
    private static String REPOSITORY;
    private static String URL = 'https://api.github.com';
    private static String ORGANIZATION;
    
    private static HttpRequest generateRequest(String endpoint, String method) {
        String authorizationHeader = 'token ' + TOKEN;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/vnd.github.v3.full+json');
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    
    private static HttpRequest generateRequest(String endpoint,String method,String body) {
        String authorizationHeader = 'token ' + TOKEN;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setBody(body);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/vnd.github.v3.full+json');
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    
    //can remove
    /*@AuraEnabled
    public static String getAllRepositories() {
        // String endpoint = URL+'/users/'+ USER+'/repos' ;
        githubDetails();
        String endpoint = URL + '/search/repositories?q=user:' + USER;
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        } else {
            System.debug('False Response - ' + res.getBody());
        }
        
        return res.getBody();
    }*/
    
    //can remove
    /*@AuraEnabled
    public static String getAllBranchesOfRepo() {
        githubDetails();
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/branches';
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }*/
    
    @AuraEnabled
    public static String getAllBranchesOfProjectRepo(String projectId) {
        projectGithubDetails(projectId);
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/branches';
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }
    
    //can remove
    /*@AuraEnabled
    public static String createPullRequest(String userStoryId, String message) {
        githubDetails();
        String[] branches = InternalController.getSourceAndTargetBranchNames(
            userStoryId
        );
        return createPullRequest(branches[0], branches[1], message);
    }*/
    
    //can remove
    /*@AuraEnabled
    public static String createPullRequest(String baseBranch, String compareBranch, String message) {
        githubDetails();
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/pulls';
        String body =
            '{"title": "' +
            message +
            '", "head":"' +
            compareBranch +
            '","base":"' +
            baseBranch +
            '"}';
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'POST', body));
        
        if (res.getStatusCode() == 201) {
            System.debug('Response - ' + res.getBody());
            
            //XmlStreamReader reader = res.getXmlStreamReader();
            
            // Read through the XML
            //while (reader.hasNext()) {
            //System.debug('Event Type:' + reader.getEventType());
            //if (reader.getEventType() == XmlTag.START_ELEMENT) {
            //    System.debug(reader.getLocalName());
            // }
            //reader.next();
            //}
            
            //System.debug('get pull number - ' + res.getHeader('number'));
            // System.debug('get pull number - ' + res.getHeaderKeys());
            
            //createMergeForPullNumber(pullNumber);
        }
        return res.getBody();
    }*/
    
    @AuraEnabled
    public static String createPullRequest(String baseBranch,String compareBranch,String message, String projectId) {
        projectGithubDetails(projectId);
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/pulls';
        String body =
            '{"title": "' +
            message +
            '", "head":"' +
            compareBranch +
            '","base":"' +
            baseBranch +
            '"}';
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'POST', body));
        
        if (res.getStatusCode() == 201) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }
    
    //can remove
    /*@AuraEnabled
    public static List<List<String>> compareBranches(
        String baseBranch,
        String compareBranch
    ) {
        githubDetails();
        String endpoint =
            URL +
            '/repos/' +
            USER +
            '/' +
            REPOSITORY +
            '/compare/' +
            baseBranch +
            '...' +
            compareBranch;
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        List<String> patches = new List<String>();
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'patch') {
                    patches.add(parser.getText());
                }
            }
        }
        List<List<String>> temp = new List<List<String>>();
        for (Integer i = 0; i < patches.size(); i++) {
            temp.add(patches[i].split('\n'));
        }
        return temp;
    }*/
    
    @AuraEnabled
    public static List<List<String>> compareBranches(String baseBranch,String compareBranch,String projectId) {
        projectGithubDetails(projectId);
        String endpoint =
            URL +
            '/repos/' +
            USER +
            '/' +
            REPOSITORY +
            '/compare/' +
            baseBranch +
            '...' +
            compareBranch;
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        List<String> patches = new List<String>();
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'patch') {
                    patches.add(parser.getText());
                }
            }
        }
        List<List<String>> temp = new List<List<String>>();
        for (Integer i = 0; i < patches.size(); i++) {
            temp.add(patches[i].split('\n'));
        }
        return temp;
    }
    
    
    private static String getBranchSHA(String branch, String projectId) {
        projectGithubDetails(projectId);
        String endpoint =
            URL +
            '/repos/' +
            USER +
            '/' +
            REPOSITORY +
            '/git/trees/' +
            branch;
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if (fieldName == 'sha') {
                        system.debug('SHA => ' + parser.getText());
                        return parser.getText();
                    }
                }
            }
        }
        //to be optimized later
        return res.getBody();
    }
    
    @AuraEnabled
    public static String createBranch(String branchName, String userStoryId) {
        User_Story__c us = [select Project__r.Id, Source__r.Id from User_Story__c where Id =: userStoryId];
        String sourceBranchName = [select Branch__c from Git_Branch__c where Org__c =: us.Source__r.Id].Branch__c;
        projectGithubDetails(us.Project__r.Id);
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/git/refs';
        String body =
            '{"ref": "refs/heads/' +
            branchName +
            '", "sha":"' +
            getBranchSHA(sourceBranchName, us.Project__r.Id) +
            '"}';
        system.debug('Body : ' + body);
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'POST', body));
        //system.debug('Code : '+res.getStatusCode());
        if (res.getStatusCode() == 201) {
            System.debug('Response - ' + res.getBody());
        }
        
        return res.getBody();
    }
    
    @AuraEnabled
    public static String getPullRequests(String projectId) {
        projectGithubDetails(projectId);
        String endpoint = URL + '/repos/' + USER + '/' + REPOSITORY + '/pulls';
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'GET'));
        //system.debug('Code : '+res.getStatusCode());
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }
    
    @AuraEnabled
    public static String createMergeForPullNumber(String pullNumber,String title, String projectId) {
        projectGithubDetails(projectId);
        String endpoint =
            URL +
            '/repos/' +
            USER +
            '/' +
            REPOSITORY +
            '/pulls/' +
            pullNumber +
            '/merge';
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'PUT'));
        //system.debug('Code : '+res.getStatusCode());
        if (res.getStatusCode() == 201) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }
    
    @AuraEnabled
    public static String closeAPullRequest(String pullNumber, String title, String projectId) {
        projectGithubDetails(projectId);
        String endpoint =
            URL +
            '/repos/' +
            USER +
            '/' +
            REPOSITORY +
            '/pulls/' +
            pullNumber;
        System.debug(endpoint);
        String body = '{"state" : "closed", "title" : "' + title + '"}';
        System.debug('Body : ' + body);
        
        Http http = new Http();
        HttpResponse res = http.send(generateRequest(endpoint, 'PATCH', body));
        //system.debug('Code : '+res.getStatusCode());
        if (res.getStatusCode() == 200) {
            System.debug('Response - ' + res.getBody());
        }
        return res.getBody();
    }
}