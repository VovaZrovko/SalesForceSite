global with sharing class CabinetController {
    public Contact contact {get;set;}
    public Id conId = ApexPages.currentPage().getParameters().get('id');
    public CabinetController() {
        contact = new Contact();
        contact.FirstName = ApexPages.currentPage().getParameters().get('FirstName');
        contact.LastName = ApexPages.currentPage().getParameters().get('LastName');
        //contact = [Select FirstName, LastName From Contact Where (Id =:conId) Limit 1];
    }
    public PageReference Logout(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }
}