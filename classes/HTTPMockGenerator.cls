@isTest
global  class HTTPMockGenerator implements HTTPCalloutMock {
    protected Integer statusCode;
    protected string data;
   
    public HTTPMockGenerator(Integer statusCode,string data){
        this.statuscode=statuscode;
        this.data=data;
    }   
    global HttpResponse respond(HTTPRequest req){
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(data);
        res.setStatusCode(statuscode);
       
        return res;
    }
}