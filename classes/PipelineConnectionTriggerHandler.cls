public class PipelineConnectionTriggerHandler {
    public static void checkSource(List<Pipeline_Connection__c> pConnections) {
        for(Pipeline_Connection__c pConnection : pConnections) {
            List<Pipeline_Connection__c> connections = [select Source_Environment__c from Pipeline_Connection__c];
            for(Pipeline_Connection__c connection : connections) {
                if(pConnection.Source_Environment__c == connection.Source_Environment__c) {
                    pConnection.Source_Environment__c.addError('There already exists a connection with this Source in this Pipeline.');
                    break;
                }
            }
        }
    }
}