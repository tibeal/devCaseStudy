@RestResource(urlMapping='/external/applications')
global with sharing class ApplicationWebhook {

    public class IllegalArgumentException extends Exception {}
    public class IllegalStateException extends Exception {}

    @HttpPost
    global static WebhookResponse handlePost() {
        WebhookResponse response = new WebhookResponse();
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();

            if (requestBody == null || String.isBlank(requestBody)) {
                throw new IllegalArgumentException('Request body is empty');
            }

            // Parse the incoming JSON payload
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            Map<String, Object> contactMap = (Map<String, Object>) payload.get('contact');

            ApplicationDTO input = new ApplicationDTO();
            input.companyName = (String) payload.get('companyName');
            input.federalTaxId = (String) payload.get('federalTaxId');
            input.annualRevenue = (Decimal) payload.get('annualRevenue');

            input.firstName = (String) contactMap.get('firstName');
            input.lastName = (String) contactMap.get('lastName');
            input.email = (String) contactMap.get('email');
            input.phone = (String) contactMap.get('phone');

            ApplicationResult expectedResult = ApplicationProcessingService.submitApplication(input, 'Webhook');

            response.success = expectedResult.success;
            response.recordType = expectedResult.recordType;
            response.recordId = expectedResult.recordId;
            response.message = expectedResult.message;
            return response;
        } catch (Exception e) {
            response.success = false;
            response.message = 'Error processing webhook: ' + e.getMessage();
            return response;
        }
    }

}