public with sharing class JenkinsCommunication {
 
  private static void setValues() {
    USERNAME = 'Admin';
    TOKEN = '1114431c68f0ca6a60f8b8b7985b578d69';
    URL = 'http://3.21.108.235';
    PORT = '8080';
    PROJECT = 'SF-poc-devops';
  }

  static String USERNAME;
  static String TOKEN;
  static String URL;
  static String PORT;
  static String PROJECT;

  private static HttpRequest generateRequest(String path, String method) {
    //path starts with / and ends without /.  
    String endpoint = URL + ':' + PORT + path + '/api/json';
    String rawToken = USERNAME + ':' + TOKEN;
    Blob tokenBlob = Blob.valueOf(rawToken);
    String authorizationHeader =
      'Basic ' + EncodingUtil.base64Encode(tokenBlob);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setMethod(method);
    req.setHeader('Authorization', authorizationHeader);
    req.setHeader('Content-Type', 'application/json');
    req.setTimeout(120000);
    return req;
  }

  private static HttpRequest generateRequest(
    String path,
    String method,
    String body
  ) {
    String endpoint = URL + ':' + PORT + path + '/api/json';
    String rawToken = USERNAME + ':' + TOKEN;
    Blob tokenBlob = Blob.valueOf(rawToken);
    String authorizationHeader =
      'Basic ' + EncodingUtil.base64Encode(tokenBlob);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setMethod(method);
    req.setBody(body);
    req.setHeader('Authorization', authorizationHeader);
    // req.setHeader('Accept', 'application/vnd.github.v3.full+json');
    req.setHeader('Content-Type', 'application/json');
    req.setTimeout(120000);
    return req;
  }

  // this method is just for basic understanding
  @AuraEnabled
  public static String getAllBuilds() {
    setValues();
    String path = '';
    Http http = new Http();
    HttpResponse res = http.send(generateRequest(path, 'GET'));

    if (res.getStatusCode() == 200) {
      System.debug('Response - ' + res.getBody());
    } else {
      System.debug('False Response - ' + res.getBody());
    }
    return res.getBody();
  }

  @AuraEnabled
  public static String getAllJobsOfABranch(String branchId) {
    setValues();
    String branchName = [select Branch__c from Git_Branch__c where Id =: branchId].Branch__c;
    String path = '/job/'+PROJECT+'/job/'+branchName;
    Http http = new Http();
    HttpResponse res = http.send(generateRequest(path, 'GET'));

    if (res.getStatusCode() == 200) {
      System.debug('Response - ' + res.getBody());
    } else {
      System.debug('False Response - ' + res.getBody());
    }
    return res.getBody();
  }

  @AuraEnabled
  public static String getBuildDetails(String branchId, String buildNumber) {
    setValues();
    String branchName = [select Branch__c from Git_Branch__c where Id =: branchId].Branch__c;
    String path = '/job/'+PROJECT+'/job/'+branchName+'/'+buildNumber;
    Http http = new Http();
    HttpResponse res = http.send(generateRequest(path, 'GET'));

    if (res.getStatusCode() == 200) {
      System.debug('Response - ' + res.getBody());
    } else {
      System.debug('False Response - ' + res.getBody());
    }
    return res.getBody();
  }
  @AuraEnabled
  public static String getBuildOnConsole(String branchId, String buildNumber) {
    setValues();
    String branchName = [select Branch__c from Git_Branch__c where Id =: branchId].Branch__c;
    String path = '/job/'+PROJECT+'/job/'+branchName+'/'+buildNumber+'/consoleText';
    Http http = new Http();
    HttpResponse res = http.send(generateRequest(path, 'GET'));

    if (res.getStatusCode() == 200) {
      System.debug('Response - ' + res.getBody());
    } else {
      System.debug('False Response - ' + res.getBody());
    }
    return res.getBody();
  }
}