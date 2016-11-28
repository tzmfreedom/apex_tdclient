public with sharing class TDClient {
    private static final String TD_API_BASE_URL = 'https://api.treasuredata.com';
    
    private String tdKey;
    
    public TDClient(String tdKey) {
        this.tdKey = tdKey;
    }
    
    private String sendHttpRequest(String method, String path, String body) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'TD1 ' + this.tdKey);
        req.setTimeout(60000);
        
        req.setEndpoint(TD_API_BASE_URL + path);
        req.setMethod(method);
        
        if (method == 'POST') {
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Content-Length', String.valueOf(body.length()));
            req.setBody(body);
        }
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
        
    }
    
    public Map<String, Object> issue(String type, String database, String table, String query) {
        String resBody = this.sendHttpRequest(
            'POST', 
            '/v3/job/issue/{type}/{database}'.replace('{type}', type)
                                             .replace('{database}', database), 
            JSON.serialize(new Map<String, String> { 'query' => query })
        );
        return (Map<String, Object>)JSON.deserializeUntyped(resBody);
    }
    
    public Map<String, Object> showJob(String jobId) {
        String resBody = this.sendHttpRequest('GET', '/v3/job/show/{job_id}'.replace('{job_id}', jobId), null);
        return (Map<String, Object>)JSON.deserializeUntyped(resBody);
    }
    
    public Map<String, Object> getStatus(String jobId) {
        String resBody = this.sendHttpRequest('GET', '/v3/job/status/{job_id}'.replace('{job_id}', jobId), null);
        return (Map<String, Object>)JSON.deserializeUntyped(resBody);
    }
    
    public String getResult(String jobId, String format) {
        return this.sendHttpRequest(
            'GET', 
            '/v3/job/result/{job_id}?format={format}'.replace('{job_id}', jobId)
                                                     .replace('{format}', format), 
            null
        );
    }
}