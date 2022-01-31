import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LogInSys from '@salesforce/apex/MyContactController.LogInSys';
export default class Login extends NavigationMixin(LightningElement) {
    yourPass;
    yourEmail;
    handleClick3(){
        let isInvalid = true;
        var data = this.template.querySelectorAll('lightning-input');
        console.log('data.value');
        data.forEach(val =>{
            if(!val.value){
                val.setCustomValidity(val.label + ' fill this field')
                isInvalid = false;
            }
            val.reportValidity();
        });
        console.log('valid ' + isInvalid);
        if(isInvalid){
            LogInSys({email:data[0].value,pass:data[1].value})
            .then(result=>{
                if(result !== ''){
                    let res = result.split(',')
                    console.log('entered');
                    let compDefinition = {
                        componentDef: "c:cabinet",
                        attributes: {
                            firstName: res[0],
                            lastName: res[1]
                        }
                    };
                    let encodedCompDef = btoa(JSON.stringify(compDefinition));
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: '/one/one.app#' + encodedCompDef
                        }
                    });
                }
            })
            .catch(error=>console.log(error))
        }
    }
    handleClick2() {
        this.navToLwc("forgotPass");
    } 
    handleClick1() {
        this.navToLwc("registrationLWC");
    } 
    navToLwc(toComp){
        var compDefinition = {
            componentDef: "c:" + toComp,
        };
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        });
    }
}