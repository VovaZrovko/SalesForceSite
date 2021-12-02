global class MyContactController {
    public Contact con {get; set;}
    public String classInputPostalCode {get;set;}
    public String classInputEmail {get;set;}
    public String classInputPassword {get;set;}
    public String errorMessage {get;set;}
    public MyContactController() {
        con = new Contact();
    }
    
    public PageReference Loggin(){
        if (String.isBlank(con.Email) ){
            errorMessage = 'Input Email';
            classInputEmail ='error'; 
            return null;
        }
        
        if (String.isBlank(con.Password__c)){
            errorMessage = 'Input Password';
            classInputPassword ='error'; 
            return null;
        }

        Contact[] existCon = [Select Id, LastName, FirstName From Contact Where (Email =:con.Email And Password__c =:con.Password__c) Limit 1];
        Contact newCon = new Contact();
        for(Contact ct: existCon){
            newCon = ct;
        }

        if (existCon.size() == 1){
            PageReference page = new PageReference('/apex/Cabinet');
            page.getParameters().put('id',newCon.id);
            return page;
        }

        errorMessage = 'There is no such contact';  
        classInputPostalCode ='error'; 
        return null;
    }
    public PageReference Regist(){
        return new PageReference('/apex/RegisterPage');
    }
    public PageReference ForgotPass(){
        return new PageReference('/apex/PasswordRecoveryPage');
    }
}