public without sharing class CabinetLWC {
    public CabinetLWC() {

    }
    public without sharing class LWCWrapper {
        @AuraEnabled
        public Boolean Ischeck { get; set;}
        @AuraEnabled
        public String ProductName { get; set;}
        @AuraEnabled
        public Boolean ProductIsBiliable { get; set;}
        @AuraEnabled
        public String Team{ get; set;} 
        @AuraEnabled
        public Decimal Budget{ get; set;} 
        @AuraEnabled
        public Date StartDate{ get; set;} 
        @AuraEnabled
        public Boolean ToDisable{ get; set;} 
        @AuraEnabled
        public String BtnLable{ get; set;} 
        @AuraEnabled
        public Id Id{ get; set;} 
        @AuraEnabled
        public String ProductId{ get; set;}
        @AuraEnabled
        public Integer TeamCount{ get; set;}
        @AuraEnabled
        public String Client{ get; set;}
        public LWCWrapper(){
            
        }
    }
    @AuraEnabled
    public static List<LWCWrapper> projData(String selectedPrice, String selectedCountTeamMembers, String selectedClientId){
        //Integer memberMin;
        //Integer memberMax;
        String query = 'Select Id, IsChecked__c, Product__c, Product__r.Id, Product__r.Name, Product__r.Client__r.Id, Product__r.Is_Billable__c, Product__r.Product_Budget__c, Product__r.Start_Date__c, Team__c,Team__r.Name, Team__r.Developer_1__c,Team__r.Developer_2__c, Team__r.Project_Manager__c From Product_Assignment__c';
        /*if(!String.isBlank(selectedPrice) && selectedPrice != 'none'){
            String[] priseString = selectedPrice.split('-');
            Integer priceMin = Integer.valueof(priseString[0]);
            Integer priceMax = Integer.valueof(priseString[1]);
            query += ' Where Product__r.Product_Budget__c >:priceMin And Product__r.Product_Budget__c <:priceMax ';
        }*/
        /*if(selectedCountTeamMembers != 'none'){
            String[] membersString = selectedCountTeamMembers.split('-');
            memberMin = Integer.valueof(membersString[0]);
            memberMax = Integer.valueof(membersString[1]);
        }*/
        List<LWCWrapper> res = new List<LWCWrapper>();
        for(Product_Assignment__c pa:Database.query(query)){
            Integer countTeam = 0;
            LWCWrapper wr = new LWCWrapper();
            wr.Id = pa.Id;
            wr.BtnLable = pa.IsChecked__c?'Checked':'UnChecked';
            wr.ProductName = pa.Product__r.Name;
            wr.ProductId = pa.Product__r.Id;
            wr.ProductIsBiliable = pa.Product__r.Is_Billable__c;
            wr.Team = ' ';
            if(pa.Team__r.Developer_1__c != null){
                wr.Team += pa.Team__r.Developer_1__c + ' ';
                countTeam+=1;
            }
            if(pa.Team__r.Developer_2__c != null){
                wr.Team += pa.Team__r.Developer_2__c + ' ';
                countTeam+=1;
            }
            if(pa.Team__r.Project_Manager__c != null){
                wr.Team += pa.Team__r.Project_Manager__c;
                countTeam+=1;
            }
            wr.ToDisable = false;
            /*wr.Client = String.valueof(pa.Product__r.Client__r.Id);
            if(pa.Product__r.Client__r.Id != null && String.valueof(pa.Product__r.Client__r.Id) != selectedClientId){
                wr.ToDisable = true;
                //wr.BtnLable = 'Checked';
            }*/
            wr.TeamCount = countTeam;
            wr.Budget = pa.Product__r.Product_Budget__c;
            wr.StartDate = pa.Product__r.Start_Date__c;
            /*if(selectedCountTeamMembers != 'none'){
                if(memberMin <= countTeam && memberMax > countTeam){
                    res.add(wr);
                }
            }*/
            //if(selectedCountTeamMembers == 'none') {
            res.add(wr);
            //}
        }
        return res;
    }
    @AuraEnabled
    public static String AssignCl(String selectedClientId, List<LWCWrapper> wrapperList){
        try{
            if(selectedClientId != 'none'){
                List<Product__c> prToUdateList = new List<Product__c>();
                List<Product_Assignment__c> paToUpdate = new List<Product_Assignment__c>();
                if(checkRecordsToAs(wrapperList, selectedClientId) <= 0){
                    return 'There is no records to assign';
                }
                for(LWCWrapper pj: wrapperList){
                    if(pj.ToDisable == false && pj.BtnLable == 'Checked'){
                        Product__c newPr = new Product__c();
                        newPr.Id = pj.ProductId;
                        newPr.Client__c = selectedClientId;
                        prToUdateList.add(newPr);
                        Product_Assignment__c pas = new Product_Assignment__c();
                        pas.Id = pj.Id;
                        pas.IsChecked__c = true;
                        paToUpdate.add(pas);
                    }
                }
                if(prToUdateList.size() > 0){
                    update prToUdateList;
                }
                if(paToUpdate.size()>0){
                    update paToUpdate;
                }
            }
            else{
                return 'Cant assign to none';
            }
        }catch(Exception e){
            return 'Error ' + e;
        }
        return 'done';
    }
    @AuraEnabled(cacheable=true)
    public static List<Client__c> GetClientsOption(){
        return [Select id, Name From Client__c];
    }
    public static Integer checkRecordsToAs(List<LWCWrapper> wrapperList,String selectedClientId){
        List<Product__c> pr1 = [Select id, Client__r.id From Product__c Where Client__r.id =:selectedClientId];
        Integer countValid = 0;
        for(LWCWrapper pj: wrapperList){
            if(pj.ToDisable == false && pj.BtnLable == 'Checked'){
                countValid +=1;
            }
        }
        countValid = countValid - pr1.size();
        return countValid;
    }
}
