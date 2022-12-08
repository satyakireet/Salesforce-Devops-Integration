import { api, LightningElement, track, wire } from 'lwc';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';
import getApexClasses from '@salesforce/apex/RetrieveMetadata.getApexClasses';
const ACOLS = [
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

export default class ApexClassesDependencies extends LightningElement {
    @track acolumn = ACOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track apexClasses = [];
    @track apexC;
    @track selectedDependencies = [];
    @track getmetadata;
    isDataAvailable = false;
    @track lst = [];
    @track test = false;
    @wire(getApexClasses) apexCl({ data, error }) {
        if (data) {
            this.apexC = data;
            this.apexC.forEach(element => {
                this.apexClasses = [...this.apexClasses, { Id: element.Id, Name: element.Name, Status: element.Status, ApiVersion: element.ApiVersion }];
            });

        } else if (error) {
            console.log("Error in getApexClasses>>" + JSON.stringify(error));
        }
        if (this.apexClasses.length) {
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
            console.log("Selected Dependencies>>" + JSON.stringify(this.selectedDependencies));
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