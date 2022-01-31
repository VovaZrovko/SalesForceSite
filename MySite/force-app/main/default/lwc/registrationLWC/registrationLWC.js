import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PASSWORD_FIELD from '@salesforce/schema/Contact.Password__c';
import createContact from '@salesforce/apex/RegisterController.createContact';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
export default class RegistrationLWC extends NavigationMixin(LightningElement) {
    /*objectApiName = CONTACT_OBJECT;
    fields = [FIRSTNAME_FIELD, LASTNAME_FIELD, EMAIL_FIELD,PASSWORD_FIELD];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }*/
    //second version
    /*
    fname;
    lname;
    email;
    pass;
    firstChangedHandler(event){
        console.log('first changed');
        this.fname = event.target.value;
    }
    lastChangedHandler(event){
        this.lname = event.target.value;
    }
    emailChangedHandler(event){
        this.email = event.target.value;
    }
    passChangedHandler(event){
        this.pass = event.target.value;
    }
    handleClick(event)
    {
        console.log('start');
        var fields = {'FirstName': this.fname, 'LastName': this.lname, 'Email': this.email, 'Password__c': this.pass};
        var objapi = {'apiName' : 'Contact', fields};
        createRecord(objapi).then(response => {
            alert('Contact created with Id: ' +response.id);
        }).catch(error => {
            alert('Error: ' +JSON.stringify(error));
        });
    }*/
    fname;
    lname;
    email;
    pass;
    handleClick(){
        let isInfalid = true;
        var data = this.template.querySelectorAll('lightning-input');
        console.log('data.value');
        data.forEach(val =>{
            if(!val.value){
                val.setCustomValidity(val.label + ' fill this field')
                isInfalid = false;
            };
            val.reportValidity();
        });
        console.log('falid ' + isInfalid);
        if(isInfalid){
            createContact({FName:data[0].value, LName:data[1].value,conEmail:data[2].value,Password:data[3].value})
            .then(result=>{
                if(result){
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Succes',
                        message: 'Created contact',
                        variant: 'success'
                    }));
                }
            })
            .catch(error=>console.log(error))
        }
    }
    Back(){
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'LWCReg'
            },
        });
    }
}