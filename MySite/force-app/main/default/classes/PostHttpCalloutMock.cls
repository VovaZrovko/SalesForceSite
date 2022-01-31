@isTest
global class PostHttpCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String bodyAsString;
    protected Map<String, String> responseHeaders;
    public PostHttpCalloutMock(Integer code, String body,
    Map<String, String> responseHeaders){
        this.code = code;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
    }
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                response.setHeader(key, responseHeaders.get(key));
            }
        }
        if(bodyAsString != ''){
            response.setBody(bodyAsString);
        }
        response.setStatusCode(code);
        return response; 
    }
}