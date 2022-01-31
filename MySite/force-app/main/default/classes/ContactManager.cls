@RestResource(urlMapping='/v1/CreateCon/*')
global class ContactManager {
    @HttpPost
    global static ID createContact(String accountName, String contactLastName, String email, String pass) {
        Savepoint sp = Database.setSavepoint();
        Contact con = new Contact();
        try {
            Account acc = new Account(Name = accountName);
            insert acc;
            con.AccountId = acc.Id;
            con.LastName = contactLastName;
            con.Email = email;
            con.Password__c = pass;
            insert con;
        } catch (Exception e ) {
            Database.rollback(sp);
            System.debug('rolled back');
        }
        return con.id;
    }  
    @HttpGet
    global static String hi(){
        return 'hi';
    }
}