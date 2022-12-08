/**
	* This class is used to generate dataset for lwc charts.
*/
public class LwcChartController {
	/*
		* This method is used to retrieve sprints of projects.
		* projectId: id of required project.
		* return: list of dataset for chart.
	*/
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getProjectSprints(String projectId){
        List<Sprint__c> sprints =  [SELECT Name,Progress__c,Status__c  FROM Sprint__c WHERE Project__c =: projectId];
        List<DataSet> dataSet = new List<DataSet>();
        for(Sprint__c sprint : sprints){
            String name =  (String)sprint.get('Name') ;
            String status =  (String)sprint.get('Status__c') ;
            Decimal total =  (Decimal)sprint.get('Progress__c') ;
            dataSet.add(new DataSet(name,total,status));
        }
        return dataSet ;
    }
    
    /*
		* This is wrapper of chart dataset.
	*/
    public class DataSet{
        /*
            * Property to store label of sprint.
        */
        @AuraEnabled
        public String label {get;set;}
        /*
            * Property to store status of sprint.
        */
        @AuraEnabled
        public String status {get;set;}
        /*
            * Property to store progress of sprint.
        */
        @AuraEnabled
        public Decimal count {get;set;}
        
        /*
            * Contructor for creating dataset with label, status, & progress of sprint.
        */
        public DataSet(String label,Decimal count,String status){
            this.label  = label ;
            this.count = count ;
            this.status = status;
        }
    }
}