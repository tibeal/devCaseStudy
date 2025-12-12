@JsonAccess(serializable='always' deserializable='always')
public with sharing class ApplicationDTO {
    @AuraEnabled public String companyName {get;set;}
    @AuraEnabled public String federalTaxId {get;set;}
    @AuraEnabled public String firstName {get;set;}
    @AuraEnabled public String lastName {get;set;}
    @AuraEnabled public String email {get;set;}
    @AuraEnabled public String phone {get;set;}
    @AuraEnabled public Decimal annualRevenue {get;set;}

    public ApplicationDTO() {}

    public ApplicationDTO(String companyName, String federalTaxId, String firstName, String lastName, String email, String phone, Decimal annualRevenue) {
        this.companyName = companyName;
        this.federalTaxId = federalTaxId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.annualRevenue = annualRevenue;
    }
}