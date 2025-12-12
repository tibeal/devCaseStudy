public with sharing class ApplicationFormController {

    @AuraEnabled
    public static ApplicationResult submitApplication(ApplicationDTO input) {
        System.debug('Received application submission: ' + JSON.serialize(input));
        return ApplicationProcessingService.submitApplication(input, 'Community');
    }
}