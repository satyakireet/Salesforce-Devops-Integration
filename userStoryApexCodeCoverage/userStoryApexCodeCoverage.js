import { api, LightningElement, track, wire } from 'lwc';
import getNonTestApexClasses from '@salesforce/apex/RetrieveMetadata.getNonTestApexClasses';
import getTestApexClasses from '@salesforce/apex/RetrieveMetadata.getTestApexClasses';
import getApexTriggers from '@salesforce/apex/RetrieveMetadata.getApexTriggers';
import getCodeCoverage from '@salesforce/apex/RunApexTestsController.getCodeCoverage';
import runTests from '@salesforce/apex/RunApexTestsController.runTests';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLS = [{ label: 'Name', fieldName: 'name' }, { label: 'Type', fieldName: 'type' }];
const RCOLS = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Test Class Available', fieldName: 'isTestClassWritten', type: 'boolean' },
    { label: 'Code Coverage', fieldName: 'coverage' },
    { label: 'Type', fieldName: 'type' }
];

export default class UserStoryApexCodeCoverage extends LightningElement {
    @api recordId;
    @track column = COLS;
    @track rcolumn = RCOLS;
    @track selectedRows;
    @track showCoverage = false;
    apexRows = [];
    testRows = [];
    @track resultRows;
    apexClasses;
    testClasses;
    apexTriggers;

    connectedCallback() {
        getTestApexClasses().then(response => {
            this.testClasses = response;
            for (const list of this.testClasses) {
                this.testRows = [...this.testRows, { name: list.Name, type: 'Test Class' }];
            }
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error Loading Data. Try Refreshing the Page.',
                    variant: 'error',
                }),
            );
        });

        getNonTestApexClasses().then(response => {
            this.apexClasses = response;
            for (const list of this.apexClasses) {
                this.apexRows = [...this.apexRows, { name: list.Name, type: 'Apex Class' }];
            }
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error Loading Data. Try Refreshing the Page.',
                    variant: 'error',
                }),
            );
        });

        getApexTriggers().then(response => {
            this.apexTriggers = response;
            for (const list of this.apexTriggers) {
                this.apexRows = [...this.apexRows, { name: list.Name, type: 'Apex Trigger' }];
            }
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error Loading Data. Try Refreshing the Page.',
                    variant: 'error',
                }),
            );
        });
    }
    runSelectedTests(event) {
        var qs = this.template.querySelectorAll('lightning-datatable');
        this.selectedRows = qs[0].getSelectedRows();
        let selectedApex = [];
        for (const list of this.selectedRows) {
            selectedApex = [...selectedApex, list.name];
        }
        console.log('Selected Apex : ' + JSON.stringify(selectedApex));
        runTests({ testClasses: selectedApex }).then(response => {
            if (response) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Apex Test Run Successful. Check Code Coverage.',
                        variant: 'success',
                    }),
                );
            }
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }

    checkCodeCoverage(event) {
        var qs = this.template.querySelectorAll('lightning-datatable');
        this.selectedRows = qs[1].getSelectedRows();
        //console.log('Selected : '+JSON.stringify(this.selectedRows));
        getCodeCoverage({ classes: this.selectedRows, userStory: this.recordId }).then(response => {
            if (response) {
                this.showCoverage = true;
                //console.log('Result : '+JSON.stringify(response));
                this.resultRows = response;
            }
        }).catch(error => {
            this.showCoverage = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }
}