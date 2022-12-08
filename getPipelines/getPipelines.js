import { LightningElement,track,wire } from 'lwc';
import getPipelines from '@salesforce/apex/gettingStartedController.getPipelines';
import getPipelineConnections from '@salesforce/apex/gettingStartedController.getPipelineConnections';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class GetPipelines extends NavigationMixin(LightningElement ){
    @track columns = [
        { label: 'Pipeline Connection Name', fieldName: 'Pipeline__c', type: 'text', sortable: true },
        { label: 'Source Environment', fieldName: 'Source_Environment__c', type: 'text', sortable: true },
        { label: 'Destination Environment', fieldName: 'Destination_Environment__c', type: 'text', sortable: true }
    ];
    @track error;
    @track pipelinesList;
    @track pipelineConnectionList;
    createPipeline = false;
    allPipelineArray = [];
    allPipelineConnectionArray = [];
    selectedValue;
    selectedValueId;
    showPipelineConnection = false;
    isDataPipeline = false;
    selectedPipeline = true;

    handleNew(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Pipeline__c',
                actionName: 'new'
            }
        });
    }
    handleNewConnectionPipeline(){
        const defaultValues = encodeDefaultFieldValues({
            Pipeline__c: this.selectedValueId
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Pipeline_Connection__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
    handleChange(event){
        this.selectedValueId = event.detail.value;
        this.showPipelineConnection = true;
        console.log("selected value id:" + this.selectedValueId);
    }

    @wire(getPipelines)
    wiredgetPipelines({ error, data }) {
        if (data) {
            this.pipelinesList = data;
            this.pipelinesList.forEach(element => {
                this.allPipelineArray = [...this.allPipelineArray, {label:element.Name,value:element.Id}];            
            });
        } else if (error) {
            this.error = error;
        }
    }
    
    @wire(getPipelineConnections,{selectedValueId:'$selectedValueId'})
    wiredgetPipelineConnections({ error, data }) {
        if (data) {
            this.pipelineConnectionList = data;
            this.allPipelineConnectionArray = [];
            let newArray = [];
            this.pipelineConnectionList.forEach(element => {
                let newObject = {};
                newObject.Id = element.Id;
                if(element.Pipeline__r.Name) {
                    newObject.Pipeline__c = element.Pipeline__r.Name;
                }
                if(element.Destination_Environment__r.Name) {
                    newObject.Destination_Environment__c = element.Destination_Environment__r.Name;
                }
                if(element.Source_Environment__r.Name) {
                    newObject.Source_Environment__c = element.Source_Environment__r.Name;
                }
                newArray.push(newObject);         
            });
            if(Array.isArray(newArray) && newArray.length) {
                this.allPipelineConnectionArray = newArray;
            }
        } else if (error) {
            this.error = error;
        }
        if(this.allPipelineConnectionArray.length){
            this.isDataPipeline = true;
        }
        if(this.allPipelineConnectionArray.length == 0){
            this.isDataPipeline = false;
        }
        console.log('isDataPipeline::' + this.isDataPipeline);
        console.log('PIPLENE CONNECTION AARAY:' + JSON.stringify(this.allPipelineArray));
    }
}