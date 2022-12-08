/**
	* This class is wrapper of all Metadata.
*/
public with sharing class MetadataWrapper {
    /**
    * Property to store name of Metadata.
    */
    @AuraEnabled
    public String name{get;set;}
    /**
    * Property to store type of Metadata.
    */
    @AuraEnabled
    public String type{get;set;}
    
    /**
    * Property to store last modified date of Metadata.
    */
    @AuraEnabled
    public Datetime lastModifiedDate{get;set;}
    
    /**
    * No parameter constructor.
    */
	public MetadataWrapper() {
    }
    
    /**
    * Parameterized constructor.
    */
    public MetadataWrapper(String n, String t) {
    	name = n;
        type = t;
    }
    
    public MetadataWrapper(String n, String t, Datetime lastModified) {
    	name = n;
        type = t;
        lastModifiedDate = lastModified;
    }
}