public without sharing class PasswordRecoveryController {
    public String emailField {get;set;}
    public String passWord {get;set;}
    public PasswordRecoveryController(){

    }
    public PageReference Back(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }
    public PageReference SendEmail(){
        if (String.isBlank(emailField)){
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,' There is no email. Input it'));
            return null;
        }
        
        List<Contact> passList = [Select Password__c From Contact Where Email =:emailField Limit 1];
        
        if(passList.size() > 0){
            passWord = passList[0].Password__c;
            System.debug('password isnt null');
            Messaging.SendEmailResult[] results = sendMail(emailField, 'Your password', passWord);
            if (results[0].success) {
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'The email was sent' ));
            } else {
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'The email failed to send: ' + results[0].errors[0].message));
            }
        }
        else{
            System.debug('password is null');
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,' There is no email' + emailField));
        }
        return null;
    }
    @AuraEnabled
    public static String sendMSG(String email){
        List<Contact> passList = [Select Password__c From Contact Where Email =:email Limit 1];
        if(passList.size() > 0 && passList[0].Password__c != null){
            String passWord = passList[0].Password__c;
            Messaging.SendEmailResult[] results = sendMail(email, 'Your password ', passWord);
            if (results[0].success) {
                return 'The email was sent';
            } else {
                return ('error, the email failed to send: ' + results[0].errors[0].message);
            }
        }
        else{
            return 'error, cant find record or pass is null';
        }
    }

    public static Messaging.SendEmailResult[] sendMail(String address, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};         
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}