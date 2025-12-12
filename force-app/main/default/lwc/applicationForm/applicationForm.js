import { LightningElement } from 'lwc';
import ToastContainer from 'lightning/toastContainer';
import Toast from 'lightning/toast';

import ApplicationFormTitle from '@salesforce/label/c.ApplicationForm';
import CompanyName from '@salesforce/label/c.CompanyName';
import FederalTaxId from '@salesforce/label/c.FederalTaxId';
import ContactFirstName from '@salesforce/label/c.ContactFirstName';
import ContactLastName from '@salesforce/label/c.ContactLastName';
import Email from '@salesforce/label/c.Email';
import Phone from '@salesforce/label/c.Phone';
import AnnualRevenue from '@salesforce/label/c.AnnualRevenue';
import Submit from '@salesforce/label/c.Submit';
import submitApplication from '@salesforce/apex/ApplicationFormController.submitApplication';

export default class ApplicationForm extends LightningElement {
    labels = {
        ApplicationFormTitle,
        CompanyName,
        FederalTaxId,
        ContactFirstName,
        ContactLastName,
        Email,
        Phone,
        AnnualRevenue,
        Submit
    };

    fields = [];
    fieldValues = {};

    loading = false;

    async connectedCallback() {
        try {
            this.loading = true;
            await this.initLWRToast();
            this.loading = false;
        } catch (error) {
            this.handleError(error);
        }
    }

    async initLWRToast() {
        const toastContainer = ToastContainer.instance();
        toastContainer.maxToasts = 5;
        toastContainer.toastPosition = 'top-center';
    }

    async handleSubmit() {
        try {
            this.fields = this.template.querySelectorAll('.form-field');
            console.log('Fields to validate: ', this.fields);
            const allValid = Array.from(this.fields).reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
            if (!allValid) {
                throw new Error('Please fix validation errors before submitting the form.');
            }
            this.fieldValues = Array.from(this.fields).reduce((acc, field) => {
                acc[field.name] = field.value;
                return acc;
            }, {});
            let payload = {
                companyName: this.fieldValues.companyName,
                federalTaxId: this.fieldValues.federalTaxId,
                firstName: this.fieldValues.firstName,
                lastName: this.fieldValues.lastName,
                email: this.fieldValues.email,
                phone: this.fieldValues.phone,
                annualRevenue: this.fieldValues.annualRevenue
            };
            console.log('Form Submitted with values: ');
            console.log(JSON.stringify(payload, null, 2));
            this.loading = true;
            const result = await submitApplication({ input: payload });
            this.loading = false;

            let message = result.success ?
                `${result.recordType} created successfully with Id: ${result.recordId}` :
                result.message;

            Toast.show({
                label: message,
                variant: result.success ? 'success' : 'error'
            }, this);

            if (result.success) {
                Array.from(this.fields).forEach((inputCmp) => {
                    inputCmp.value = null;
                });
            }

        } catch (error) {
            this.handleError(error);
            this.loading = false;
        }
        this.loading = false;
    }

    handleError(error) {
        try {
            console.error(error);
            let errorMessage = error?.body?.message ||
                error?.name && error.name + ':' + error?.message ||
                error?.body && error?.body?.pageErrors?.[0]?.message;
            Toast.show({
                label: errorMessage,
                mode:'sticky',
                variant:'error'
            }, this);
        } catch (error) {
            console.error(error);
        }
    }
}