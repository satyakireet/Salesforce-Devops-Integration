import { api, LightningElement, track, wire } from 'lwc';
import getMetadataComponentDependency from '@salesforce/apex/RetrieveMetadata.getMetadataComponentDependency';
import getCustomApplication from '@salesforce/apex/RetrieveMetadata.getCustomApplication';
const ACOLS = [
    { label: 'Developer Name', fieldName: 'DeveloperName' },
    { label: 'Label', fieldName: 'Label' },
    { label: 'Nav Type', fieldName: 'NavType' },
    { label: 'UI Type', fieldName: 'UiType' }
];
const SCOLS = [
    { label: 'Metadata Component Name', fieldName: 'MetadataComponentName' },
    { label: 'Metadata Component Type', fieldName: 'MetadataComponentType' },
    { label: 'Ref Metadata Component Name', fieldName: 'RefMetadataComponentName' },
    { label: 'Ref Metadata Component Type', fieldName: 'RefMetadataComponentType' },
];

export default class CustomApplicationDependencies extends LightningElement {
    @track acolumn = ACOLS;
    @track scolumn = SCOLS;
    @track selectedRowIds;
    @track showDependencies = false;
    @track cappData = [];
    @track caData;
    @track selectedDependencies = [];
    @track getmetadata;
    isDataAvailable = false;
    @track lst = [];
    @track test = false;
    @wire(getCustomApplication) coData({ data, error }) {
        if (data) {
            this.caData = data;
            this.caData.forEach(element => {
                this.cappData = [...this.cappData, { Id: element.Id, DeveloperName: element.DeveloperName, Description: element.Description, NamespacePrefix: element.NamespacePrefix, IsNavAutoTempTabsDisabled: element.IsNavAutoTempTabsDisabled, IsNavPersonalizationDisabled: element.IsNavPersonalizationDisabled, Label: element.Label, NavType: element.NavType, UiType: element.UiType, UtilityBarId: element.UtilityBarId, ManageableState: element.ManageableState }];
            });
        } else if (error) {
            console.log("Error in getApexClasses>>" + JSON.stringify(error));
        }
        if (this.cappData.length) {
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