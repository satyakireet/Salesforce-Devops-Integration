import { LightningElement, track } from 'lwc';
import getNonTestApexClasses from '@salesforce/apex/RetrieveMetadata.getNonTestApexClasses';
import getTestApexClasses from '@salesforce/apex/RetrieveMetadata.getTestApexClasses';
import getApexTriggers from '@salesforce/apex/RetrieveMetadata.getApexTriggers';
import getCodeCoverageOfClasses from '@salesforce/apex/RunApexTestsController.getCodeCoverageOfClasses';
import runTests from '@salesforce/apex/RunApexTestsController.runTests';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLS = [{ label: 'Name', fieldName: 'name' }, { label: 'Type', fieldName: 'type' }];
const RCOLS = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Test Class Available', fieldName: 'isTestClassWritten', type: 'boolean' },
    { label: 'Code Coverage', fieldName: 'coverage' },
    { label: 'Type', fieldName: 'type' }
];

export default class ApexCodeCoverage extends LightningElement {
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
        //this.apexRows.push({name:'Test',type:'Apex Class'});
        getTestApexClasses().then(response => {
            this.testClasses = response;
            for (const list of this.testClasses) {
                this.testRows = [...this.testRows, { name: list.Name, type: 'Test Class' }];
            }
        }).catch(error => {
            //console.error(error);
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
            //console.log('Classes : '+this.apexClasses[0].Name);
            for (const list of this.apexClasses) {
                //console.log('row : '+list.Name);
                this.apexRows = [...this.apexRows, { name: list.Name, type: 'Apex Class' }];
                //this.apexRows.push({name:list.Name,type:'Apex Class'});
            }
        }).catch(error => {
            //console.error(error);
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
            //console.error(error);
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
            //console.error(error);
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
        //console.log('QS : '+qs);
        this.selectedRows = qs[1].getSelectedRows();
        console.log('Selected : ' + JSON.stringify(this.selectedRows));
        // let selectedApex = [];
        // for(const list of this.selectedRows) {
        //     //console.log('row : '+list.name);
        //     selectedApex.push(list.name);
        // }
        // console.log('Selected Apex : '+JSON.stringify(selectedApex));
        getCodeCoverageOfClasses({ classes: this.selectedRows }).then(response => {
            if (response) {
                this.showCoverage = true;
                console.log('Result : ' + JSON.stringify(response));
                this.resultRows = response;
            }
        }).catch(error => {
            this.showCoverage = false;
            //console.error(error);
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