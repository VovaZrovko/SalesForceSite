global class CabinetController {
    public Contact contact {get;set;}
    public Id conId {get;set;}
    public List<Product_Assignment__c> pjList {get;set;}
    public ApexPages.StandardSetController standardSetController {get;set;}
    public String selectedPrice {get;set;}
    public Boolean IsChecked {get;set;}
    public String selectedCountTeamMembers {get;set;}
    public Integer pageSize = 5;

    public CabinetController() {
        conId = ApexPages.currentPage().getParameters().get('id');
        contact = [Select FirstName, LastName From Contact Where (Id =:conId) Limit 1];
        loadData();
    }
    public void loadData(){
        String query = 'Select Product__r.Name, Product__r.Is_Billable__c, Product__r.Product_Budget__c, Product__r.Start_Date__c, Team__r.Name, Team__r.Developer_1__c,Team__r.Developer_2__c, Team__r.Project_Manager__c From Product_Assignment__c '; 
        if(!String.isBlank(selectedPrice) && selectedPrice != 'none'){
            String[] priseString = selectedPrice.split('-');
            Integer priceMin = Integer.valueof(priseString[0]);
            Integer priceMax = Integer.valueof(priseString[1]);
            query += ' Where Product__r.Product_Budget__c >:priceMin And Product__r.Product_Budget__c <:priceMax ';
        }
        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
		assignData();
    }
    public void assignData(){
        pjList = new List<Product_Assignment__c>();
        List<Sobject> sobj = standardSetController.getRecords();
        if(sobj.size()>0){
            for(Sobject obj:sobj){
                Product_Assignment__c pa = (Product_Assignment__c)obj;
                if(String.isBlank(selectedCountTeamMembers) || selectedCountTeamMembers == 'none'){
                    pjList.add(pa);
                }
                else{
                    checkFilter(selectedCountTeamMembers, pa);
                } 
            }
        }
    }
    public void checkFilter(String selectedCountTeamMembers, Product_Assignment__c pa){
        String[] membersString = selectedCountTeamMembers.split('-');
        Integer memberMin = Integer.valueof(membersString[0]);
        Integer memberMax = Integer.valueof(membersString[1]);
        Integer tempCount = countTeamMembers(pa);
        if(memberMin < tempCount && memberMax > tempCount){
            pjList.add(pa);
        }
    }
    public Integer countTeamMembers(Product_Assignment__c pa){
        Integer countMember = 0;
        if(pa.Team__r.Developer_1__c != null){
            countMember+=1;
        }
        if(pa.Team__r.Developer_2__c != null){
            countMember+=1;
        }
        if(pa.Team__r.Project_Manager__c != null){
            countMember+=1;
        }
        return countMember;
    }
    public List<SelectOption> GetPriceOptins(){
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('none','none'));
        so.add(new SelectOption('0-100','0-100'));
        so.add(new SelectOption('100-1000','100-1000'));
        so.add(new SelectOption('1000-10000','1000-10000'));
        return so;
    }
    public List<SelectOption> GetMemberCounOptins(){
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('none','none'));
        so.add(new SelectOption('0-3','0-3'));
        so.add(new SelectOption('4-7','4-7'));
        so.add(new SelectOption('7-10','7-10'));
        return so;
    }
    public void SelectMember(){
        loadData();
    }
    public void SelectPrice(){
        loadData();
    }
    public PageReference Logout(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }
    public void First(){
		standardSetController.first();
        assignData();
    }

    public void Next(){
		standardSetController.next();
        assignData();
    }

    public void Previous(){
		standardSetController.previous();
        assignData();
    }

    public void Last(){
		standardSetController.last();
        assignData();
    }

    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }
    public Integer GetTotalPages(){
        return (Integer)math.ceil((Decimal)standardSetController.getResultSize() / (Decimal)pageSize);
    }
}