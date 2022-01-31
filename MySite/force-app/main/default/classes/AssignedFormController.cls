public with sharing class AssignedFormController {
    public AssignedFormController() {
    }
    @AuraEnabled(cacheable=true)
    public static String  ClientName(String clientId){
        if(clientId == 'none'){
            return 'none';
        }else{
            return [Select id, Name From Client__c Where id =:clientId Limit 1].Name;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Product_Assignment__c> ClientFields(String clientId){
        if(clientId == 'none'){
            return null;
        }else{
            return [Select Id, Product__c, Product__r.Name, Product__r.Is_Billable__c, Team__r.Name From Product_Assignment__c Where Product__r.Client__r.Id =:clientId];
        }
    }
}