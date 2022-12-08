public class GitComm {
	public static void getFromGithub(){
        HTTP h = new HTTP();
        HTTPRequest r = new HTTPRequest();
        r.setEndpoint('callout:MyGitHubApiConnect/api/v3/');
        Blob headerValue = Blob.valueOf('RaghavSoni11' + ':' + 'Imagron@1101');
        String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
        r.setHeader('Authorization', authorizationHeader);
        //r.setHeader('If-Modified-Since', 'Thu, 05 Jul 2012 15:31:30 GMT');
        r.setHeader('Accept', 'application/json');
        r.setHeader('Content-Type', 'application/json');
        r.setMethod('GET');
        try
        {
            HTTPResponse resp1 = h.send(r);
            System.debug('Response Body - '+ resp1.getBody());
            // Changed in the code.
      
        }catch (Exception e)
        {
            
        }
    }
    public static void postToGithub(){
        String body = '{as : fd}';
        HTTP h = new HTTP();
        HTTPRequest r = new HTTPRequest();
        //r.setEndpoint('https://api.github.com/Himanshupate');
        r.setEndpoint('https://api.github.com/repos/Himanshupate/temp');
        Blob headerValue = Blob.valueOf('Himanshupate' + ':' + '12@github');
        String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
        r.setHeader('Authorization', authorizationHeader);
        //r.setHeader('If-Modified-Since', 'Thu, 05 Jul 2012 15:31:30 GMT');
        r.setHeader('Accept', 'application/json');
        r.setHeader('Content-Type', 'application/json');
        r.setMethod('POST');
        r.setBody(body);
        try
        {
            HTTPResponse resp1 = h.send(r);
            System.debug('Response - '+ resp1.getBody()); 
            
        }catch (Exception e)
        {}
    }
}