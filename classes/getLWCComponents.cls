public with sharing class getLWCComponents {
    
    @AuraEnabled(cacheable=true)
    public static List<ApexClass> getApexClasses() {
        return [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, IsValid, LastModifiedById, 
                LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status, SystemModstamp 
                from ApexClass LIMIT 10];
    }
    @AuraEnabled(cacheable=true)
    public static List<ApexTrigger> getApexTriggers() {
        return [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, IsValid, LastModifiedById, 
                LastModifiedDate, LengthWithoutComments, Name, NamespacePrefix, Status, SystemModstamp 
                from ApexTrigger LIMIT 10];
    }
    @AuraEnabled(cacheable=true)
    public static List<ApexPage> getApexPages() {
        return [select Id,  Name from ApexPage LIMIT 10];
    }
    @AuraEnabled(cacheable=true)
    public static List<EmailTemplate> getEmailTemplate() {
        return [select Description, Name, Subject from EmailTemplate LIMIT 10];
    }
    /*
    @AuraEnabled(cacheable=true)
    public static Object getLightningComponents1(String sessionId){
        Object o = getLightningComponents( sessionId);
        return o;
    }*/
    
    
    @AuraEnabled
    public static Object getLightningComponents1(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+Id+FROM+LightningComponentBundle');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        system.debug('response'+res.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('Map Object '+ results.get('records'));
        //String accountsJSON = JSON.createGenerator(jsonString)
        return results.get('records');
    }
    
    public static Integer getLWCCount() {
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:MetadataFetching/services/data/v50.0/tooling/query/?q=SELECT+count()+FROM+LightningComponentBundle');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );  
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        system.debug('response'+res.getBody());
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('Size '+ results.get('size'));
        return (Integer)results.get('size');
    }
    
    @AuraEnabled
    public static List<MetadataWrapper> getAllMetadata1() {
        ToolingAPI ta = new ToolingAPI();
        List<MetadataWrapper> mw = new List<MetadataWrapper>();
        
        List<ToolingAPI.ApexClass> classes = (List<ToolingAPI.ApexClass>) ta.query('Select Id, Name, createdById, lastModifiedDate From ApexClass').records;
        List<ToolingAPI.ApexTrigger> triggers = (List<ToolingAPI.ApexTrigger>) ta.query('Select Id,Name,createdById,lastModifiedDate From ApexTrigger').records;
        //List<ToolingAPI.EmailTemplate> emailTemplates = (List<ToolingAPI.EmailTemplate>) toolingAPI.query('Select Id, body, fullname,,lastModifiedDate createdById From EmailTemplate').records;
        List<ToolingAPI.ApexPage> pages = (List<ToolingAPI.ApexPage>) ta.query('Select Id,Name,createdById,lastModifiedDate From ApexPage').records;   
        
        for(ToolingAPI.ApexClass ac : classes) {
            mw.add(new MetadataWrapper(ac.Name,'Apex Class', ac.lastModifiedDate));
        }
        for(ToolingAPI.ApexTrigger at : triggers) {
            mw.add(new MetadataWrapper(at.Name,'Apex Trigger', at.lastModifiedDate));
        }
        for(ToolingAPI.ApexPage ap : pages) {
            mw.add(new MetadataWrapper(ap.Name,'Apex Page', ap.lastModifiedDate));
        }
        //for(EmailTemplate et : emailTemplates) {
        //  mw.add(new MetadataWrapper(et.Name,'Email Template'));
        //}
        
        return mw;
    }
    
    
    @AuraEnabled
    public static List<MetadataWrapper> getAllMetadata() {
        List<MetadataWrapper> mw = new List<MetadataWrapper>();
        List<ApexClass> classes = getApexClasses() ;
        List<ApexTrigger> triggers = getApexTriggers();
        List<EmailTemplate> emailTemplates = getEmailTemplate();
        List<ApexPage> pages = getApexPages();
        for(ApexClass ac : classes) {
            mw.add(new MetadataWrapper(ac.Name,'Apex Class'));
        }
        for(ApexTrigger at : triggers) {
            mw.add(new MetadataWrapper(at.Name,'Apex Trigger'));
        }
        for(ApexPage ap : pages) {
            mw.add(new MetadataWrapper(ap.Name,'Apex Page'));
        }
        for(EmailTemplate et : emailTemplates) {
            mw.add(new MetadataWrapper(et.Name,'Email Template'));
        }
        
        return mw;
    }

     
    
}