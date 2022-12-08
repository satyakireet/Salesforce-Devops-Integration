import { LightningElement, wire, track } from 'lwc';
import getPendingProjects from '@salesforce/apex/InternalController.getPendingProjects';
import getPendingSprints from '@salesforce/apex/InternalController.getPendingSprints';

export default class ShowPendingItems extends LightningElement {
    @track columns = [{ label: 'Project Name', fieldName: 'Name', type: 'text', sortable: true },
    { label: 'Project Start Date', fieldName: 'Start_Date__c', type: 'text', sortable: true },
    { label: 'Project End Date', fieldName: 'End_Date__c', type: 'text', sortable: true },
    { label: 'Project Status', fieldName: 'Status__c', type: 'text', sortable: true, cellAttributes: { class: { fieldName: "statusCSSClass" } } }];

    @track cols = [{ label: 'Sprint Name', fieldName: 'Name', type: 'text', sortable: true },
    { label: 'Sprint Start Date', fieldName: 'Start_Date__c', type: 'text', sortable: true },
    { label: 'Sprint End Date', fieldName: 'End_Date__c', type: 'text', sortable: true },
    { label: 'Project Name', fieldName: 'Project__c', type: 'text', sortable: true },
    { label: 'Sprint Status', fieldName: 'Status__c', type: 'text', sortable: true, cellAttributes: { class: { fieldName: "statusCSSClass" } } }];

    pendingProjects;
    pendingSprints;
    allProjectArray = [];
    allSprintArray = [];
    error;
    activeSections = ['Projects', 'Sprints'];
    connectedCallback(){
        this.PendingProjects();
        this.PendingSprints();
    }
    // constructor() {
    //     super();
    //     this.PendingProjects();
    //     super();
    //     this.pendingSprints();
    // }
    PendingProjects() {
        getPendingProjects().then(result => {
            let resultArray = [];
            result.forEach((element) => {
                let metricdata = {};
                metricdata.Name = element.Name;
                metricdata.Start_Date__c = element.Start_Date__c;
                metricdata.End_Date__c = element.End_Date__c;
                metricdata.Status__c = element.Status__c;

                if (metricdata.Status__c === 'Draft') {
                    metricdata.statusCSSClass = 'slds-text-color_error slds-text-title_bold';
                } else if (metricdata.Status__c === 'Planned') {
                    metricdata.statusCSSClass = 'slds-theme_shade slds-text-title_bold';
                } else if (metricdata.Status__c === 'In Progress') {
                    metricdata.statusCSSClass = 'slds-text-color_weak slds-text-title_bold';
                } else {
                    metricdata.statusCSSClass = 'slds-text-color_success slds-text-title_bold';
                }

                resultArray.push(metricdata);
            });
            this.allProjectArray = resultArray;
            console.log('Print Element:::' + JSON.stringify(this.allProjectArray));
            this.error = undefined;
        })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while getting Projects',
                        message: error.message,
                        variant: 'error'
                    }),
                );
                this.data = undefined;
            });
    }

    PendingSprints() {
        getPendingSprints().then(result => {
            let resultArray = [];
            result.forEach((element) => {
                let metricdata = {};
                metricdata.Name = element.Name;
                metricdata.End_Date__c = element.End_Date__c;
                metricdata.Start_Date__c = element.Start_Date__c;
                metricdata.Status__c = element.Status__c;
                if(element.Project__r.Name) {
                    metricdata.Project__c = element.Project__r.Name;
                }
                if (metricdata.Status__c === 'Draft') {
                    metricdata.statusCSSClass = 'slds-text-color_error slds-text-title_bold';
                } else if (metricdata.Status__c === 'Planned') {
                    metricdata.statusCSSClass = 'slds-theme_shade slds-text-title_bold';
                } else if (metricdata.Status__c === 'In Progress') {
                    metricdata.statusCSSClass = 'slds-text-color_weak slds-text-title_bold';
                } else {
                    metricdata.statusCSSClass = 'slds-text-color_success slds-text-title_bold';
                }

                resultArray.push(metricdata);
            });
            this.allSprintArray = resultArray;
            console.log('Print Element:::' + JSON.stringify(this.allSprintArray));
            this.error = undefined;
        })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while getting Sprints',
                        message: error.message,
                        variant: 'error'
                    }),
                );
                this.data = undefined;
            });
    }

}