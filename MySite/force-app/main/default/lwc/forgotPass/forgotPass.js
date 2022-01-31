import { LightningElement } from 'lwc';
import sendMSG from '@salesforce/apex/PasswordRecoveryController.sendMSG'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class ForgotPass extends NavigationMixin(LightningElement) {
    yourEmail;
    error;
    handleChange(event){
        this.yourEmail = event.target.value;
    }
    handleClick1(){
        console.log('clicked')
        let data = this.template.querySelector('lightning-input');
        console.log('data = ' + data);
        let value = data.value;
        console.log(value + ' val')
        sendMSG({email:value})
        .then(result =>{
            console.log('res = ' + result.includes('error'));
            if(result.includes('error')){
                this.error = 'r';
                this.dispatchEvent(new ShowToastEvent({
                title: 'ERROR',
                message: result,
                variant: 'error'
                }));
            }else{
                this.error = 's';
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Succes',
                    message: result,
                    variant: 'success'
                }));
            }
        })
        .catch(error=> {this.error = error});
        this.yourEmail = '';
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