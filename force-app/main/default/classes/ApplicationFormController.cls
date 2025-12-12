public with sharing class ApplicationFormController {

    @AuraEnabled
    public static ApplicationResult submitApplication(ApplicationDTO input) {
        try {
            System.debug('Received application submission: ' + JSON.serialize(input));
            return ApplicationProcessingService.submitApplication(input, 'Community');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}