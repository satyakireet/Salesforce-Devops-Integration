trigger PipelineConnectionTrigger on Pipeline_Connection__c (before insert, before update) {
	if(Trigger.isInsert) {
        PipelineConnectionTriggerHandler.checkSource(Trigger.new);
    }
    if(Trigger.isUpdate) {
        
    }
}