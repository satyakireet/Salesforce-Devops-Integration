import { api, LightningElement, track, wire } from 'lwc';
import getLightningComponents from '@salesforce/apex/RetrieveMetadata.getLightningComponents';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';

const LCOLS = [
    { label: 'Name', fieldName: 'DeveloperName' },
    { label: 'Api Version', fieldName: 'ApiVersion' }
];
const SCOLS = [
    { label: 'Metadata Component Name', fieldName: 'MetadataComponentName' },
    { label: 'Metadata Component Type', fieldName: 'MetadataComponentType' },
    { label: 'Ref Metadata Component Name', fieldName: 'RefMetadataComponentName' },
    { label: 'Ref Metadata Component Type', fieldName: 'RefMetadataComponentType' },
];
export default class LwcDependencies extends LightningElement {
    @track lcolumn = LCOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track lightningComponentsBundle = [];
    @track lightningComponents;
    @track selectedDependencies = [];
    @track getmetadata;
    @track isDataAvailable = false;
    @track lst = [];
    test = false;
    @wire(getLightningComponents) getL({ data, error }) {
        if (data) {
            this.lightningComponents = data;
            this.lightningComponents.forEach(element => {
                this.lightningComponentsBundle = [...this.lightningComponentsBundle, { Id: element.Id, DeveloperName: element.DeveloperName, ApiVersion: element.ApiVersion }];
            });
        } else if (error) {
            console.log("Error in lightningComponentsBundle" + JSON.stringify(error));
        }
        if (this.lightningComponentsBundle.length) {
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
            console.log("Selected Dependdencies Data>>" + JSON.stringify(this.selectedDependencies));
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