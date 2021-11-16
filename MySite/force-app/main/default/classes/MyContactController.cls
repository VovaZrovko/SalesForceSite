global class MyContactController {
    public Contact con {get; set;}
    public String classInputPostalCode {get;set;}
    public String errorMessage {get;set;}
    public MyContactController() {
        con = new Contact();
    }
    
    public PageReference Loggin(){
        Contact[] existCon = [Select Id, LastName, FirstName From Contact Where (Email =:con.Email And Password__c =:con.Password__c) Limit 1];
        Contact newCon = new Contact();
        for(Contact ct: existCon){
            newCon = ct;
        }
        if(existCon.size() == 1){
            PageReference page = new PageReference('/apex/Cabinet');
            page.getParameters().put('id',newCon.id);
            page.getParameters().put('FirstName',newCon.FirstName);
            page.getParameters().put('LastName',newCon.LastName);
            return page;
        }
        //PageReference tempPage = new PageReference('/apex/HomePage');   
        errorMessage = 'There is no such contact';  
        classInputPostalCode ='error'; 
        return null;
    }
}