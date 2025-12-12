@isTest
public class ApplicationWebhookTest {
    
    @isTest
    static void testHandlePost_Success() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/external/applications';
        req.httpMethod = 'POST';

        req.requestBody = Blob.valueOf(
            '{"companyName": "Acme Corp", "federalTaxId": "BG123456789", "contact": { "firstName": "Ivan", "lastName": "Ivanov", "email": "ivan@example.com", "phone": "+359888123456" }, "annualRevenue": 500000}'
        );

        RestContext.request = req;
        RestContext.response = res;

        // When
        Test.startTest();

            WebhookResponse result = ApplicationWebhook.handlePost();

        Test.stopTest();

        Assert.areEqual(true, result.success, 'Application submission should be successful. Error: ' + result.message);
    }
}