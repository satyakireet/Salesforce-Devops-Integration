public class ConnectAnotherOrg {
    public static void getApexClass() {
        String str='User';
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        req.setEndpoint('callout:Authorize_an_Org/services/data/v50.0/tooling/query/?q=SELECT+Id+FROM+ApexClass+offset+1');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        
        system.debug('response'+res.getBody());
        String temp=res.getBody();
        //ApexClass ap = (ApexClass)System.JSON.deserialize(temp, ApexClass.class);
        /*JSONParser jp = JSON.createParser(temp);
        while (jp.nextToken() != null) {
            if ((jp.getCurrentToken() == JSONToken.FIELD_NAME)) {
                system.debug('Grand total=' + jp.getText());
                jp.nextToken();
            }
        }
        
        MetadataWrapper wrapper = (MetaDataWrapper) JSON.deserializeStrict(temp, MetadataWrapper.class);
        system.debug('records'+wrapper.size);*/
        
        system.debug('records'+ temp);
    }
}