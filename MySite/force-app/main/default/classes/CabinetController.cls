global without sharing class CabinetController {
    public Contact contact {get;set;}
    public Id conId {get;set;}
    public List<WrapperPJ> wrapperList {get;set;}
    public List<Client__c> clientList {get;set;}
    public ApexPages.StandardSetController standardSetController {get;set;}
    public String selectedPrice {get;set;}
    public String selectedCountTeamMembers {get;set;}
    public String selectedClientId {get;set;}
    public Integer pageSize = 5;
    public String messageToSocial {get;set;}
    public Boolean isGetCode {get;set;}
    public String authCodeFromURL { get; set; }
    public String callBackUrl {get;set;}
    public Final String consumerKey = '77svafrhktkkk0';
    public Final String consumerSecret ='l63WM2wZ4HFNk5fd';
    public String linkedln_Scope = 'r_liteprofile%20w_member_social';
    public Final String linkedln_AuthUrl = 'https://www.linkedin.com/oauth/v2/authorization?';
    public Final String accessToken_Endpoint = 'https://www.linkedin.com/oauth/v2/accessToken';

    public CabinetController(String s){

    }

    public CabinetController() {
        authCodeFromURL = ApexPages.currentPage().getParameters().get('code');
        if(authCodeFromURL == null || authCodeFromURL == ''){
            isGetCode = false;
        }
        else{
            isGetCode = true;
        }
        
        conId = ApexPages.currentPage().getParameters().get('id');
        contact = [Select FirstName, LastName From Contact Where (Id =:conId) Limit 1];
        callBackUrl = 'https://devzrovko-developer-edition.na163.force.com/Cabinet?id=' + conId;
        loadData();
    }
    
    public void loadData(){
        String query = 'Select Id, IsChecked__c, Product__c, Product__r.Id, Product__r.Name, Product__r.Client__r.Id, Product__r.Is_Billable__c, Product__r.Product_Budget__c, Product__r.Start_Date__c, Team__c,Team__r.Name, Team__r.Developer_1__c,Team__r.Developer_2__c, Team__r.Project_Manager__c From Product_Assignment__c '; 
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
        wrapperList = new List<WrapperPJ>();
        List<Sobject> sobj = standardSetController.getRecords();
        if(sobj.size()>0){
            for(Sobject obj:sobj){
                Product_Assignment__c pa = (Product_Assignment__c)obj;
                if(String.isBlank(selectedCountTeamMembers) || selectedCountTeamMembers == 'none'){
                    checkClient(pa);
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
        if(memberMin <= tempCount && memberMax > tempCount){
            checkClient(pa);
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
        so.add(new SelectOption('3-7','3-7'));
        so.add(new SelectOption('7-10','7-10'));
        return so;
    }
    
    public List<SelectOption> GetClientsOptions(){
        List<SelectOption> so = new List<SelectOption>();
        List<Client__c> clListl = [Select id, Name From Client__c];
        so.add(new SelectOption('none','none'));
        for(Client__c cl:clListl){
            so.add(new SelectOption(cl.id,cl.Name));
        }
        return so;
    }

    public void checkClient(Product_Assignment__c pa){
        try{
            WrapperPJ wp = new WrapperPJ();
            wp.pjList = pa.clone(false, true, true, true);
            wp.IdPA = pa.id;
            if(pa.Product__r.Client__r.Id != null && String.valueof(pa.Product__r.Client__r.Id) != selectedClientId){
                wp.toDisable = true;
            }
            wrapperList.add(wp);
        }
        catch(Exception e){
            System.debug('ERROR');
        }

    }

    public void SelectMember(){
        loadData();
    }

    public void SelectPrice(){
        loadData();
    }

    public void SelectClient(){
        loadData();
    }
    
    public PageReference AssignClients(){
        if(selectedClientId != 'none'){
            List<Product__c> prToUdateList = new List<Product__c>();
            List<Product_Assignment__c> paToUpdate = new List<Product_Assignment__c>();
            if(checkRecordsToAssign(wrapperList) <= 0){
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'There is no records to assign'));
                return null;
            }
            for(WrapperPJ pj: wrapperList){
                if(pj.toDisable == false && pj.pjList.IsChecked__c == true){
                    Product__c newPr = new Product__c();
                    newPr.Id = pj.pjList.Product__r.Id;
                    newPr.Client__c = selectedClientId;
                    prToUdateList.add(newPr);
                    Product_Assignment__c pas = new Product_Assignment__c();
                    pas.Id = pj.IdPA;
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
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Cant assign to none'));
        }
        return null;
    }

    public Integer checkRecordsToAssign(List<WrapperPJ> wrapperList){
        List<Product__c> pr1 = [Select id, Client__r.id From Product__c Where Client__r.id =:selectedClientId];
        Integer countValid = 0;
        for(WrapperPJ pj: wrapperList){
            if(pj.toDisable == false && pj.pjList.IsChecked__c == true){
                countValid +=1;
            }
        }
        countValid = countValid - pr1.size();
        return countValid;
    }

    public PageReference Logout(){
        PageReference prefPage = new PageReference('/apex/HomePage');
        return prefPage;
    }

    public PageReference PostSocial(){
        String requestoAuthURL = linkedln_AuthUrl + 'response_type=code&client_id='+consumerKey+'&scope='+linkedln_Scope + '&state=12345567dggd' +'&redirect_uri='+callBackUrl;
        PageReference pageRef = new PageReference(requestoAuthURL);

        return pageRef;
    }
    public void MakeCall(){
        String token = SendMessage();
        if(token != ''){
            String personId = getPersonalId(token);
            if(personId != ''){
                MakePost(token,personId);
            }
        }
    }
    public String SendMessage(){
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        String requestTokenBody = '?grant_type=authorization_code&client_id='+consumerKey+'&client_secret='+consumerSecret+'&code='+authCodeFromURL+'&redirect_uri=' + callBackUrl;
        httpReq.setMethod('GET');
        httpReq.setEndpoint(accessToken_Endpoint + requestTokenBody);
        httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpRes = http.send(httpReq);
        String accessToken = '';
        if(httpRes.getStatusCode() == 200){
            Map<String,object> TokenInfo = (Map<String,object>)JSON.deserializeUntyped(httpRes.getBody());
            accessToken = String.valueOf(TokenInfo.get('access_token'));
        }
        else{
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'problem with token' + httpRes.getStatus() +' and Status Code '+httpRes.getStatuscode()));
        }
        return accessToken;
    }

    public String getPersonalId(String Token){
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        httpReq.SetMethod('GET');
        httpReq.setEndpoint('https://api.linkedin.com/v2/me');
        httpReq.setHeader('Authorization', 'Bearer '+Token);
        httpRes = http.send(httpReq);
        String userId = '';
        if(httpRes.getStatusCode() == 200){
            Map<String,object> UserInfo = (Map<String,object>)JSON.deserializeUntyped(httpRes.getBody());
            userId = String.valueOf(UserInfo.get('id'));
        }
        else{
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'problem with Id' + httpRes.getStatus() +' and Status Code '+httpRes.getStatuscode()));
        }
        return userId;

    }

    public void MakePost(String Token, String userId){
        Http httpPost = new Http();
        HttpRequest httpReqPost = new HttpRequest();
        HttpResponse httpResPost = new HttpResponse();
        httpReqPost.SetMethod('POST');
        httpReqPost.setEndpoint('https://api.linkedin.com/v2/ugcPosts');
        httpReqPost.setHeader('Authorization', 'Bearer '+Token);
        httpReqPost.setHeader('Content-Type', 'application/json');
        httpReqPost.setHeader('X-Restli-Protocol-Version' , '2.0.0');
        String requestBody ='{'+
                                '"author": "urn:li:person:'+userId+'",'+
                                '"lifecycleState": "PUBLISHED",'+
                                '"specificContent": {'+
                                    '"com.linkedin.ugc.ShareContent": {'+
                                        '"shareCommentary": {'+
                                            '"text": "'+ messageToSocial + ' This is my first Share on LinkedIn!"'+
                                        '},'+
                                        '"shareMediaCategory": "NONE"'+
                                    '}'+
                                '},'+
                                '"visibility": {'+
                                    '"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"'+
                                '}'+
                            '}';
        httpReqPost.setBody(requestBody);
        httpResPost = httpPost.send(httpReqPost);
        if(httpResPost.getStatusCode() == 200 || httpResPost.getStatusCode() == 201){
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Posted'));
        }
        else{
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'problem with post Status '+httpResPost.getStatus()+' and Status Code '+httpResPost.getStatuscode()));
        }
    }
    public without sharing class WrapperPJ {
        public Product_Assignment__c pjList {get;set;}
        public Boolean toDisable {get;set;}
        public String IdPA {get;set;}
        public WrapperPJ(){
            pjList = new Product_Assignment__c();
            toDisable = false;
        }
    }
}