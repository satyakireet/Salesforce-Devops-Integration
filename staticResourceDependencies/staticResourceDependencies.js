import { api, LightningElement, track, wire } from 'lwc';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';
import getStaticResource from '@salesforce/apex/RetrieveMetadata.getStaticResource';
const ACOLS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Content Type', fieldName: 'ContentType' },
    { label: 'Cache Control', fieldName: 'CacheControl' }
];
const SCOLS = [
    { label: 'Metadata Component Name', fieldName: 'MetadataComponentName' },
    { label: 'Metadata Component Type', fieldName: 'MetadataComponentType' },
    { label: 'Ref Metadata Component Name', fieldName: 'RefMetadataComponentName' },
    { label: 'Ref Metadata Component Type', fieldName: 'RefMetadataComponentType' },
];

export default class StaticResourceDependencies extends LightningElement {
    @track acolumn = ACOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track srData = [];
    @track sData;
    @track selectedDependencies = [];
    @track getmetadata;
    isDataAvailable = false;
    @track lst = [];
    @track test = false;
    @wire(getStaticResource) nData({ data, error }) {
        if (data) {
            this.sData = data;
            this.sData.forEach(element => {
                this.srData = [...this.srData, { Id: element.Id, Name: element.Name, Body: element.Body, ContentType: element.ContentType, CacheControl: element.CacheControl, ManageableState: element.ManageableState }];
            });
        } else if (error) {
            console.log("Error in getApexClasses>>" + JSON.stringify(error));
        }
        if (this.srData.length) {
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