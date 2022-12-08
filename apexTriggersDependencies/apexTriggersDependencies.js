import { api, LightningElement, track, wire } from 'lwc';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';
import getApexTriggers from '@salesforce/apex/RetrieveMetadata.getApexTriggers';
const TCOLS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Status', fieldName: 'Status' },
    { label: 'ApiVersion', fieldName: 'ApiVersion' }
];
const SCOLS = [
    { label: 'Metadata Component Name', fieldName: 'MetadataComponentName' },
    { label: 'Metadata Component Type', fieldName: 'MetadataComponentType' },
    { label: 'Ref Metadata Component Name', fieldName: 'RefMetadataComponentName' },
    { label: 'Ref Metadata Component Type', fieldName: 'RefMetadataComponentType' },
];

export default class ApexTriggersDependencies extends LightningElement {
    @track tcolumn = TCOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track apexTriggers = [];
    @track apexT;
    @track selectedDependencies = [];
    @track getmetadata;
    lst = [];
    isDataAvailable = false;
    test = false;
    @wire(getApexTriggers) apexTr({ data, error }) {
        if (data) {
            this.apexT = data;
            this.apexT.forEach(element => {
                this.apexTriggers = [...this.apexTriggers, { Id: element.Id, Name: element.Name, Status: element.Status, ApiVersion: element.ApiVersion }];
            });
        } else if (error) {
            console.log("Error in getApexTriggers>>" + JSON.stringify(error));
        }
        if (this.apexTriggers.length) {
            this.isDataAvailable = true;
        } else {
            this.isDataAvailable = false;
        }
    }
    @wire(getMetadataComponentDependency, { ids: '$selectedRowIds' }) getmcd({ data, error }) {
        if (data) {
            this.getmetadata = data;
            this.selectedDependencies = [];
            this.getmetadata.forEach(element => {
                this.selectedDependencies = [...this.selectedDependencies, { MetadataComponentName: element.MetadataComponentName, MetadataComponentType: element.MetadataComponentType, RefMetadataComponentName: element.RefMetadataComponentName, RefMetadataComponentType: element.RefMetadataComponentType }];
            });
        } else if (error) {
            console.log("getMetadataComponentDependency Error>>" + JSON.stringify(error));
        }
        if (this.selectedDependencies.length) {
            this.showDependencies = true;
        } else {
            this.showDependencies = false;
        }
    }
    testmetadata(event) {
        var qs = this.template.querySelector('.ytest');
        var tempString = '';
        var srows = qs.getSelectedRows();
        console.log("SROWS" + JSON.stringify(srows));
        srows.forEach(element => {
            tempString += '\'' + element.Id + '\',';
        });
        this.selectedRowIds = tempString.slice(0, -1);
        console.log("Selected Row Ids>>" + this.selectedRowIds);
        this.test = true;
        if (this.selectedRowIds === '') {
            this.test = false;
        }
    }
    handleListPagination(event) {
        this.lst = [...event.detail.records];
    }
}