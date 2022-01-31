import { LightningElement,api, wire, track } from 'lwc';
import ClientName from '@salesforce/apex/AssignedFormController.ClientName';
import ClientFields from '@salesforce/apex/AssignedFormController.ClientFields';
import { refreshApex } from '@salesforce/apex';
export default class AssignedForm extends LightningElement {
    @api client;
    error;
    @track fields;
    clientName;
    isLoading = true;
    wiredFeedElements;
    @wire(ClientName,{clientId:'$client'})
    wireClientName(result){
        if(result.data){
            this.clientName = result.data;
        }
        this.checkLoading();
    }
    @wire(ClientFields,{clientId:'$client'})
    wireClientFields(value){
        this.wiredFeedElements = value;
        let data = value.data;
        if(data){
            this.fields = data;
        }
        this.checkLoading();
    }
    @api handeForceChangeClient(){
        refreshApex(this.wiredFeedElements);
    }

    checkLoading(){
        this.isLoading = this.client === 'none';
    }
    exit(){
        this.isLoading = true;
    }
}