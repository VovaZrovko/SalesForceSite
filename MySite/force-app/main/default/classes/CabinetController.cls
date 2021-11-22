global class CabinetController {
    public Contact contact {get;set;}
    public Id conId {get;set;}

    public CabinetController() {
        conId = ApexPages.currentPage().getParameters().get('id');
        contact = [Select FirstName, LastName From Contact Where (Id =:conId) Limit 1];
    }

    public PageReference Logout(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }
}