/**
* This class is main bridge between Salesforce Org and DevOps Framework.
* This class retrieves Metadata from Org and show it on User Story.
*/
public with sharing class RetrieveMetadata {
    /**
* This method wraps all the Metadata available in org. 
* return: list of all Metadata.
*/
    @AuraEnabled(cacheable=true)
    public static List<MetadataWrapper> getAllMetadata() {
        List<MetadataWrapper> mw = new List<MetadataWrapper>();
        List<ApexClass> classes = getApexClasses() ;
        List<ApexTrigger> triggers = getApexTriggers();
        List<EmailTemplate> emailTemplates = getEmailTemplate();
        for(ApexClass ac : classes) {
            mw.add(new MetadataWrapper(ac.Name,'Apex Class'));
        }
        for(ApexTrigger at : triggers) {
            mw.add(new MetadataWrapper(at.Name,'Apex Trigger'));
        }
        for(EmailTemplate et : emailTemplates) {
            mw.add(new MetadataWrapper(et.Name,'Email Template'));
        }
        
        return mw;
    }
    
    /**
* This method retrieves all the apex classes available in org. 
* return: list of all apex classes.
*/
    @AuraEnabled(cacheable=true)
    public static List<ApexClass> getApexClasses() {
        return [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, IsValid, LastModifiedById, 
                LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status, SystemModstamp 
                from ApexClass];
    }    
    /**
* This method retrieves all the non test apex classes available in org. 
* return: list of all apex classes.
*/
    @AuraEnabled(cacheable=true)
    public static List<ApexClass> getNonTestApexClasses() {
        List<ApexClass> testClasses = getTestApexClasses();
        return [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, IsValid, LastModifiedById, 
                LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status from ApexClass where ID NOT IN : testClasses];
    }
    
    /**
* This method retrieves all the test apex classes available in org. 
* return: list of all apex classes.
*/
    @AuraEnabled(cacheable=true)
    public static List<ApexClass> getTestApexClasses() {
        return [FIND '@isTest' IN ALL FIELDS RETURNING ApexClass(Id, ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, IsValid, LastModifiedById, 
                                                                 LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status)][0];
    }
    
    /**
* This method retrieves all the apex triggers available in org. 
* return: list of all apex triggers.
*/
    @AuraEnabled(cacheable=true)
    public static List<ApexTrigger> getApexTriggers() {
        return [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, IsValid, LastModifiedById, 
                LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status, SystemModstamp 
                from ApexTrigger];
    }
    /**
* This method retrieves all the email templates available in org. 
* return: list of all email templates.
*/
    private static List<EmailTemplate> getEmailTemplate() {
        return [select Description, Name, Subject from EmailTemplate];
    }
    
    /*public static List<ToolingAPI.LightningComponentBundle> getLWC() {
ToolingAPI toolingAPI = new ToolingAPI();
String query = 'select Id, DeveloperName from LightningComponentBundle';
List<ToolingAPI.LightningComponentBundle> lwcs = (List<ToolingAPI.LightningComponentBundle>)toolingAPI.query().records;
return lwcs;
}*/
    
    /**
* This method retrieves all the CustomObject available in org. 
* return: list of all CustomObject.
*/
    @AuraEnabled(cacheable=true)
    public static Object getCustomObject(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+CustomHelpId+,+DeveloperName+,+ExternalName+,+ExternalRepository+,+ManageableState+,+NamespacePrefix+,+SharingModel+,+Language+,+Description+FROM+CustomObject');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the CustomField available in org. 
* return: list of all CustomField.
*/
    @AuraEnabled(cacheable=true)
    public static Object getCustomField(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+DeveloperName+,+ManageableState+,+NamespacePrefix+,+TableEnumOrId+FROM+CustomField');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the Flow available in org. 
* return: list of all Flow.
*/
    @AuraEnabled(cacheable=true)
    public static Object getFlow(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+VersionNumber+,+MasterLabel+,+Status+,+FullName+,+ManageableState+,+Description+,+DefinitionId+,+IsTemplate+,+ProcessType+FROM+Flow');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the Lightning Components available in org. 
* return: list of all Lightning Components.
*/
    @AuraEnabled(cacheable=true)
    public static Object getLightningComponents(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+ApiVersion+,+DeveloperName+FROM+LightningComponentBundle');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString)
        return results.get('records');
    }
    
    /**
* This method retrieves all the CustomApplication available in org. 
* return: list of all CustomApplication.
*/
    @AuraEnabled(cacheable=true)
    public static Object getCustomApplication(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+DeveloperName+,+Description+,+IsNavAutoTempTabsDisabled+,+IsNavPersonalizationDisabled+,+Label+,+ManageableState+,+NamespacePrefix+,+NavType+,+UiType+,+UtilityBarId+FROM+CustomApplication');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the FieldMapping available in org. 
* return: list of all FieldMapping.
*/
    @AuraEnabled(cacheable=true)
    public static Object getFieldMapping(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+DeveloperName+,+SobjectType+,+MasterLabel+,+FieldMappingClientId+,+Language+FROM+FieldMapping');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the GlobalValueSet available in org. 
* return: list of all GlobalValueSet.
*/
    @AuraEnabled(cacheable=true)
    public static Object getGlobalValueSet(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+Description+,+MasterLabel+FROM+GlobalValueSet');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the MetadataPackage available in org. 
* return: list of all MetadataPackage.
*/
    @AuraEnabled(cacheable=true)
    public static Object getMetadataPackage(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+PackageCategory+,+Name+FROM+MetadataPackage');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the NamedCredential available in org. 
* return: list of all NamedCredential.
*/
    @AuraEnabled(cacheable=true)
    public static Object getNamedCredential(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+DeveloperName+,+Password+,+PrincipalType+,+Username+,+Protocol+,+Endpoint+,+MasterLabel+,+OauthScope+FROM+NamedCredential');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the Profile available in org. 
* return: list of all Profile.
*/
    @AuraEnabled(cacheable=true)
    public static Object getProfile(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+Name+,+Description+FROM+Profile');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the StaticResource available in org. 
* return: list of all StaticResource.
*/
    @AuraEnabled(cacheable=true)
    public static Object getStaticResource(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+Name+,+Body+,+ContentType+,+CacheControl+,+ManageableState+FROM+StaticResource');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the User available in org. 
* return: list of all User.
*/
    @AuraEnabled(cacheable=true)
    public static Object getUser(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+Name+,+FirstName+,+LastName+,+Username+,+WorkspaceId+FROM+User');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    
    /**
* This method retrieves all the ValidationRule available in org. 
* return: list of all ValidationRule.
*/
    @AuraEnabled(cacheable=true)
    public static Object getValidationRule(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+,+Active+,+ValidationName+,+Description+,+ManageableState+,+ErrorMessage+,+ErrorDisplayField+,+EntityDefinitionId+FROM+ValidationRule');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
    }
    /**
* This method retrieves all the Metadata Component Dependency available in org. 
* return: list of all Metadata Component Dependency.
*/
    @AuraEnabled(cacheable=true)
    public static Object getMetadataComponentDependency(String ids){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+MetadataComponentId+,+MetadataComponentName+,+MetadataComponentNamespace+,+MetadataComponentType+,+RefMetadataComponentId+,+RefMetadataComponentName+,+RefMetadataComponentNamespace+,+RefMetadataComponentType+FROM+MetadataComponentDependency+where+RefMetadataComponentId+in+('+ids+')');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        System.debug('Response'+res.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //String accountsJSON = JSON.createGenerator(jsonString);
        return results.get('records');
        
    }
}