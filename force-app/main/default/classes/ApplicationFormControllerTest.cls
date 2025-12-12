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
    }
}