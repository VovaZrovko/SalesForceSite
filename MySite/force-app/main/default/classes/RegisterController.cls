global class RegisterController {
    public Contact con {get;set;}
    public String classInputPostalCode {get;set;}
    public String classInputLastName {get;set;}
    public String classInputEmail {get;set;}
    public String classInputPassword {get;set;}
    public String errorMessage {get;set;}
    public RegisterController() {
        con = new Contact();
    }
    public PageReference Submit(){
        if (String.isBlank(con.LastName)){
            errorMessage = 'Input LastName';
            classInputLastName ='error'; 
            return null;
        }

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

        Contact[] contactList = [Select Id From Contact Where Email =:con.Email Limit 1];
        if(contactList.size() == 0){
            insert con;
            PageReference page = new PageReference('/apex/HomePage');
            //page.getParameters().put('id',con.id);
            return page;
        }else {
            errorMessage = 'Exist contact with this email and password';  
            classInputPostalCode ='error'; 
            return null;
        }
    }
    public PageReference Back(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }

}
