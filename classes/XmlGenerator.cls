/**
	* This class is used to generate XML file of selected Metadata.
*/
public with sharing class XmlGenerator {
    /**
    * This method is outermost method to generate XML code.
    * This method is called from outside component. 
    * selectedMetadata: list of all the selected metadata for commit.
    * userStoryId: id of user story for which commiting metadata.
    */
    @AuraEnabled
    public static void generateXml(List<MetadataWrapper> selectedMetadata, String userStoryId, String commitDesc) {
        Set<String> selectedTypes = new Set<String>();
        for(MetadataWrapper mw : selectedMetadata) {
            selectedTypes.add(mw.type);
        }
        
        createCommit(userStoryId, commitDesc, createPackageXml(selectedMetadata, selectedTypes));
    }
    
    /**
    * Support method of generateXML to create XML.
    * This method is generates the XML code needed. 
    * selectedMetadata: list of all the selected metadata for commit.
    * selectedTypes: set of types of metadata selected.
    */
    private static DOM.Document createPackageXml(List<MetadataWrapper> selectedMetadata, Set<String> selectedTypes) {
        DOM.Document doc = new DOM.Document();
        dom.XmlNode packages = doc.createRootElement('Package', null, null);
        packages.setAttribute('xmlns', 'http://soap.sforce.com/2006/04/metadata');
        for(String type : selectedTypes) {
            dom.XmlNode body = packages.addChildElement('types', null, null);
            body.addChildElement('name', null, null).addTextNode(type);
            for(MetadataWrapper mw : selectedMetadata) {
                if(mw.type == type) {
                    body.addChildElement('members', null, null).addTextNode(mw.name);
                }
            }
        }	
        dom.XmlNode version = packages.addChildElement('version', null, null);
        version.addTextNode('50.0');
        return doc;
    }
    
    /**
    * Support method of generateXML to create Commit.
    * userStoryId: id of user story for which commiting metadata.
    * doc: XML code.
    */
    private static void createCommit(String userStoryId, String cdesc, DOM.Document doc) {
        Commit__c ucommit = new Commit__c();
        ucommit.User_Story__c = userStoryId;
        ucommit.Description__c = cdesc;
        insert ucommit;
        
        Blob body = Blob.valueOf(doc.toXmlString());
        createAttachment(body, ucommit);
    }
    
    /**
    * Support method of createCommit to create attachment of XML file in commit.
    * body: XML code body.
    * com: latest commit for user story.
    */
    private static void createAttachment(Blob body, Commit__c com) {
        Attachment aFile = new Attachment();
        aFile.Name = 'package.xml';
        aFile.IsPrivate = false;
        aFile.ParentId = com.Id;
        aFile.Body = body;
        insert aFile;
    }
}