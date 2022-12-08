trigger UserStoryTrigger on User_Story__c (after insert) {
    if(Trigger.isInsert) {
        UserStoryTriggerHandler.createFeatureBranch(JSON.serialize(Trigger.new));
    }
}