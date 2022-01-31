public class RestApi {
	//String requestoAuthURL = linkedln_AuthUrl + 'response_type=code&client_id='+consumerKey+'&scope='+linkedln_Scope + '&state=12345567dggd' +'&redirect_uri='+callBackUrl;
    public Final String linkedln_AuthUrl = 'https://www.linkedin.com/oauth/v2/authorization?';
    public Final String consumerKey = '77svafrhktkkk0';
    public String linkedln_Scope = 'r_liteprofile%20w_member_social';
    public Final String callBackUrl = 'https://issoft57-dev-ed.lightning.force.com/lightning/n/LWCReg';
    public String authCodeFromURL { get; set; }
    public RestApi(){
        
    }
    //@AuraEnabled
    //public static String Send(){
        //return 'https://www.linkedin.com/oauth/v2/authorization?' + 'response_type=code&client_id='+'77svafrhktkkk0'+'&scope='+'r_liteprofile%20w_member_social' + '&state=12345567dggd' +'&redirect_uri='+'https://devzrovko-developer-edition.na163.force.com/HomePage';
    //}
    @AuraEnabled
    public static String MakeCall(){
        String token = 'AQXo3U7dOrJITw8dAFH82_iM8PX0GG4OkGXr-eXwp0DltjwErMyWabTCPyRgyTylFJpf2KKtVhfsN1I2sSUfyijaQyBw24mVrhR83HufF4Epol06pOGL9r6T_dzktcp88z2N3djBdWjwlOj-oBheGnYlmGtvNAnsZ0uL-KVSDdjF57YIqacVH63fTMpMqOfFNKVIaik6xD13hgwPMeSsKshxz_VvDw8IzqlsHoxk-DzGg86yuF_v8WozurTm_WjBJuqW_Cnlr5sgIwybvh6CLCjPGAEHbu8xKsW4R4l6nOw4QqFFlXkYT8em-6vtpVFTfEIHi6sXJkTtHHifQ0Z_YYqgMxhfRQ';
        if(token != ''){
            String personId = RestApi.getPersonalId(token);
            if(personId != ''){
                RestApi.MakePost(token,personId);
                return 'done';
            }

        }
        return '';
        
    }

    public static String getPersonalId(String Token){
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
            throw new applicationException('problem with post Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode());
        }
        /*
        if(userId != ''){
            MakePost(Token,userId);
        }

        catch(System.Exception e){
            String errorMessage = 'Unexpected Error while getting ID. '+'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }*/
        return userId;

    }

    public static void MakePost(String Token, String userId){
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
                                            '"text": "'+ 'hi from LWC' + ' This is my first Share on LinkedIn!"'+
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
            
        }
        else{
            throw new applicationException('problem with post Status '+httpResPost.getStatus()+' and Status Code '+httpResPost.getStatuscode());
        }
        /*catch(System.Exception e){
            String errorMessage = 'Unexpected Error Post message. '+'Status '+httpResPost.getStatus()+' and Status Code '+httpResPost.getStatuscode();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }   */
    }
    public class applicationException extends Exception {}
}