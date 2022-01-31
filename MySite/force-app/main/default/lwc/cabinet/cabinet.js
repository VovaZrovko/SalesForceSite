import { LightningElement, api, track } from 'lwc';
import projData from '@salesforce/apex/CabinetLWC.projData';
import GetClientsOption from '@salesforce/apex/CabinetLWC.GetClientsOption';
import AssignCl from '@salesforce/apex/CabinetLWC.AssignCl';
import MakeCall from '@salesforce/apex/RestApi.MakeCall';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Cabinet extends NavigationMixin(LightningElement) {
    @api firstName;
    @api lastName;
    valueTeam='none';
    valueBudget='none';
    @api valueClient='none';
    @track data;
    @track dataShow;
    clientOptions;
    error;
    connectedCallback(){
        this.retrieveData();
        GetClientsOption()
        .then(result=>this.clientOptions = result)
        .catch(error => this.error = error);
    }
    /*
    @wire(projData,{selectedPrice:'$valueBudget',selectedCountTeamMembers:'$valueTeam',selectedClientId:'$valueClient'})
    projects(result){
        this.refreshVal = result;
        if(result.data){
            this.data = result.data;
        }
    }*/
    retrieveData(){
        projData({selectedPrice:this.valueBudget,selectedCountTeamMembers:this.valueTeam,selectedClientId:this.valueClient})
        .then(result => {this.data = result; this.dataShow = this.data;})
        .catch(error => this.error = error);
    }
    get clients(){
        let opt = [{ label: 'none', value: 'none' }];
        for(let i in this.clientOptions){
            opt.push({ label: this.clientOptions[i].Name, value: this.clientOptions[i].Id });
        }
        return opt;
    }

    get budgetOptions() {
        return [
            { label: 'none', value: 'none' },
            { label: '0-100', value: '0-100' },
            { label: '100-1000', value: '100-1000' },
            { label: '1000-10000', value: '1000-10000' },
        ];
    }
    get teamoOtions() {
        return [
            { label: 'none', value: 'none' },
            { label: '0-3', value: '0-3' },
            { label: '3-7', value: '3-7' },
            { label: '7-10', value: '7-10' },
        ];
    }

    col = [
        {
            label: 'IsSelected',
            type: 'button',
            typeAttributes: {
                title: 'Preview',
                variant: 'base',
                alternativeText: 'View',
                disabled: { fieldName: 'ToDisable' },
                label: { fieldName: 'BtnLable' },
                name: { fieldName: 'BtnLable' },
            }
        },
        {label: 'Product Name', fieldName: 'ProductName' },
        {label: 'Is Billable', fieldName: 'ProductIsBiliable', type: 'boolean' },
        {label: 'Team', fieldName: 'Team' },
        {label: 'Budget', fieldName: 'Budget' ,type: 'currency', typeAttributes: { currencyCode: 'EUR' }},
        {label: 'Start Date', fieldName: 'StartDate', type: "date-local",typeAttributes:{month: "2-digit", day: "2-digit" }},
    ];
    logOut(){
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'LWCReg'
            },
        });
    }
    handleChange(event){
        if(event.target.name === 'pbudget'){
            this.valueBudget = event.detail.value;
            console.log('changed b');
            //this.ChangeByBudget(this.valueBudget);
        }
        if(event.target.name === 'teamcount'){
            this.valueTeam = event.detail.value;
            console.log('changed t');
            //this.ChangeByTeam(this.valueTeam);
        }
        if(event.target.name === 'client'){
            this.valueClient = event.detail.value;
            console.log('changed c');
            this.template.querySelector("c-assigned-form").handeForceChangeClient();
            //console.log(JSON.stringify(this.data));
        }
        this.changeByBudget(this.valueBudget,this.valueTeam,this.valueClient);
        //console.log(JSON.stringify(this.data));
        //this.retrieveData();
    }
   
    changeName(event){
        console.log('handle click btn');
        //console.log(JSON.stringify(event.detail.action));
        //console.log(JSON.stringify(event.detail.row));
        //console.log(event.detail.row.BtnLable);
        let tempWrap = [];
        try{
            for(let el of this.dataShow){
                if(event.detail.row.Id === el.Id){
                    el.BtnLable = event.detail.row.BtnLable==='Checked' ? 'UnChecked':'Checked';
                }
                tempWrap.push(el);
            }
            this.dataShow = tempWrap;
        }catch(e){
            console.log('error' + e);
        }
        
    }
    assign(){
        AssignCl({selectedClientId:this.valueClient, wrapperList:this.dataShow})
        .then(result=>{
            console.log(result);
            this.retrieveData();
            console.log('child');
            this.template.querySelector("c-assigned-form").handeForceChangeClient();
        })
    }
    send(){
        MakeCall({})
        .then(res=>{
            if(res === 'done'){
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Succes',
                    message: res,
                    variant: 'success'
                }));
            }
        })
        .catch(error=>{this.error = error;})
    }
    changeByBudget(bud, team, cl){
        try{
            this.dataShow = this.data;
            if(bud == 'none' && team == 'none'){
                this.dataShow = this.data;
            }
            else if(bud == 'none'){
                let boundary = team.split('-');
                this.dataTeam = [];
                for(let el of this.dataShow){
                    if(el.TeamCount >= boundary[0] && el.TeamCount < boundary[1]){
                        this.dataTeam.push(el);
                    }
                }
                this.dataShow = this.dataTeam;
            }
            else if(team == 'none'){
                let boundary = bud.split('-');
                this.dataBud = [];
                for(let el of this.dataShow){
                    if(el.Budget > boundary[0] && el.Budget < boundary[1]){
                        this.dataBud.push(el);
                    }
                }
                this.dataShow = this.dataBud;
            }
            else{
                let boundary = bud.split('-');
                this.dataBut = [];
                for(let el of this.dataShow){
                    if(el.Budget > boundary[0] && el.Budget < boundary[1]){
                        this.dataBut.push(el);
                    }
                }
                let boundaryt = team.split('-');
                this.dataTeam = [];
                for(let el of this.dataBut){
                    if(el.TeamCount >= boundaryt[0] && el.TeamCount < boundaryt[1]){
                        this.dataTeam.push(el);
                    }
                }
                this.dataShow = this.dataTeam;
            }
            if(cl != 'none'){
                let temp = [];
                for( let el of this.dataShow){
                    el.ToDisable = false;
                    if(el.Client != null && el.Client != cl){
                        el.ToDisable = true;
                    }
                    temp.push(el);
                }
                this.dataShow = temp;
            }
        }
        catch(e){
            console.log(e);
        }
    }
}