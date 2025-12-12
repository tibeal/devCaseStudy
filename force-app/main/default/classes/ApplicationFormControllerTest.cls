@isTest
public class ApplicationFormControllerTest {
    
    @isTest
    static void submitApplication() {
        // Arrange
        ApplicationDTO input = new ApplicationDTO();
        input.firstName = 'John';
        input.lastName = 'Doe';
        input.email = 'john.doe@example.com';
        input.companyName = 'Acme Corp';
        input.federalTaxId = 'BG123456789';
        input.phone = '123-456-7890';
        input.annualRevenue = 500000;
        ApplicationResult expectedResult = ApplicationFormController.submitApplication(input);

        Assert.areEqual(true, expectedResult.success, 'Application submission should be successful.');
        Assert.areEqual('Lead', expectedResult.recordType, 'Record type should be Lead.');
    }

    @isTest
    static void submitApplicationError() {
        // Arrange
        ApplicationDTO input = new ApplicationDTO();
        input.email = 'john.doe@example.com';
        input.companyName = 'Acme Corp';
        input.federalTaxId = 'BG123456789';
        input.phone = '123-456-7890';
        input.annualRevenue = 500000;
        ApplicationResult expectedResult = ApplicationFormController.submitApplication(input);

        Assert.areEqual(false, expectedResult.success, 'Application submission should be successful.');
    }

    @isTest
    static void submitApplicationOpp() {

        Account acc = new Account(
            Name = 'Acme Corp',
            Federal_Tax_ID__c = 'BG123456789'
        );
        insert acc;

        // Arrange
        ApplicationDTO input = new ApplicationDTO();
        input.firstName = 'John';
        input.lastName = 'Doe';
        input.email = 'john.doe@example.com';
        input.companyName = 'Acme Corp';
        input.federalTaxId = 'BG123456789';
        input.phone = '123-456-7890';
        input.annualRevenue = 500000;
        ApplicationResult expectedResult = ApplicationFormController.submitApplication(input);

        expectedResult = ApplicationFormController.submitApplication(input);
        Assert.areEqual(true, expectedResult.success, 'Application submission should be successful.');
        Assert.areEqual('Opportunity', expectedResult.recordType, 'Record type should be Opportunity.');
    }
}