import { api, LightningElement, track, wire } from 'lwc';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';
import getFlow from '@salesforce/apex/RetrieveMetadata.getFlow';
const ACOLS = [
    { label: 'Master Label', fieldName: 'MasterLabel' },
    { label: 'Process Type', fieldName: 'ProcessType' },
    { label: 'Version Number', fieldName: 'VersionNumber' }
];
const SCOLS = [
    { label: 'Metadata Component Name', fieldName: 'MetadataComponentName' },
    { label: 'Metadata Component Type', fieldName: 'MetadataComponentType' },
    { label: 'Ref Metadata Component Name', fieldName: 'RefMetadataComponentName' },
    { label: 'Ref Metadata Component Type', fieldName: 'RefMetadataComponentType' },
];

export default class FlowDependencies extends LightningElement {
    @track acolumn = ACOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track flowData = [];
    @track fData;
    @track selectedDependencies = [];
    @track getmetadata;
    isDataAvailable = false;
    @track lst = [];
    @track test = false;
    @wire(getFlow) coData({ data, error }) {
        if (data) {
            this.fData = data;
            this.fData.forEach(element => {
                this.flowData = [...this.flowData, { Id: element.Id, Status: element.Status, FullName: element.FullName, ManageableState: element.ManageableState, Description: element.Description, DefinitionId: element.DefinitionId, IsTemplate: element.IsTemplate, VersionNumber: element.VersionNumber, MasterLabel: element.MasterLabel, ProcessType: element.ProcessType }];
            });
        } else if (error) {
            console.log("Error in getApexClasses>>" + JSON.stringify(error));
        }
        if (this.flowData.length) {
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