public with sharing class ApplicationProcessingService {

    public class IllegalArgumentException extends Exception {}
    public class IllegalStateException extends Exception {}

    public static ApplicationResult submitApplication(ApplicationDTO payload, String applicationSource) {

        if (payload == null) {
            throw new IllegalArgumentException('Payload cannot be null');
        }

        if (String.isBlank(payload.federalTaxId)) {
            throw new IllegalArgumentException('Federal Tax ID is required');
        }

        List<Account> existingAccount = [SELECT Id FROM Account WHERE Federal_Tax_ID__c = :payload.federalTaxId LIMIT 1];

        if (existingAccount.isEmpty()) {
            existingAccount = [SELECT Id FROM Account WHERE Name = :payload.companyName LIMIT 1];
        }

        ApplicationResult result = new ApplicationResult();

        try {
            if (existingAccount.isEmpty()) {
                Lead newLead = new Lead();
                newLead.FirstName = payload.firstName;
                newLead.LastName = payload.lastName;
                newLead.Company = payload.companyName;
                newLead.Email = payload.email;
                newLead.Phone = payload.phone;
                newLead.Federal_Tax_ID__c = payload.federalTaxId;
                newLead.Application_Source__c = applicationSource;
                Database.insert(newLead);

                result.success = true;
                result.recordType = 'Lead';
                result.recordId = newLead.Id;
                result.message = 'Lead created successfully with Id: ' + newLead.Id;

                return result;
            } else {
                Opportunity newOpportunity = new Opportunity();
                newOpportunity.Name = payload.companyName + ' - New Application';
                newOpportunity.StageName = 'Prospecting';
                newOpportunity.CloseDate = System.today().addDays(30);
                newOpportunity.AccountId = existingAccount[0].Id;
                newOpportunity.Application_Source__c = applicationSource;
                insert newOpportunity;

                result.success = true;
                result.recordType = 'Opportunity';
                result.recordId = newOpportunity.Id;
                result.message = 'Opportunity created successfully with Id: ' + newOpportunity.Id;
                return result;
            }
        } catch (Exception e) {
            result.success = false;
            result.message = 'Error processing application: ' + e.getMessage();
            return result;
        }
    }
}