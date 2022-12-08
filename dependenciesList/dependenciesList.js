import { api, LightningElement, track, wire } from 'lwc';
import getPicklistOptions from '@salesforce/apex/DevOpsController.getPicklistOptions';
export default class DependenciesList extends LightningElement {
    @track isLWC = false;
    @track isApexClass = false;
    @track isApexTrigger = false;
    @track isCustomObject = false;
    @track isValidationRule = false;
    @track isUser = false;
    @track isStaticResource = false;
    @track isProfile = false;
    @track isNamedCredential = false;
    @track isMetadataPackage = false;
    @track isGlobalValueSet = false;
    @track isFieldMapping = false;
    @track isCustomApplication = false;
    @track isFlow = false;
    @track isCustomField = false;
    //@track picklst = [];
    @wire(getPicklistOptions) list;
    // @wire(getPicklistOptions) list({ data, error }) {
    //     if (data) {
    //         this.picklst = data;
    //         this.picklst.forEach(element => {
    //             this.metadataLst = [...this.metadataLst, { isDefault: element.isDefault, value: element.value, label: element.label }];
    //         });
    //         console.log("List>" + JSON.stringify(this.picklst));
    //         console.log("List>" + JSON.stringify(this.metadataLst));
    //     } else if (error) {
    //         console.log("Error in getPicklistOptions" + JSON.stringify(error));
    //     }

    // };
    get options() {
        var metadataLst = [];
        if (this.list.data) {
            this.list.data.forEach(element => {
                metadataLst.push({ isDefault: element.isDefault, value: element.value, label: element.label });
            });
        }
        return metadataLst;
    }
    setDefaultParameter() {
        this.isApexClass = false;
        this.isLWC = false;
        this.isApexTrigger = false;
        this.isCustomApplication = false;
        this.isCustomField = false;
        this.isFieldMapping = false;
        this.isGlobalValueSet = false;
        this.isMetadataPackage = false;
        this.isProfile = false;
        this.isStaticResource = false;
        this.isUser = false;
        this.isValidationRule = false;
        this.isFlow = false;
        this.isNamedCredential = false;
        this.isCustomObject = false;
    }
    handleChange(event) {
            this.value = event.detail.value;
            this.setDefaultParameter();
            switch (this.value) {
                case 'Apex Classes':
                    this.isApexClass = true;
                    break;
                case 'Apex Triggers':
                    this.isApexTrigger = true;
                    break;
                case 'Lightning Component Bundle':
                    this.isLWC = true;
                    break;
                case 'Custom Object':
                    this.isCustomObject = true;
                    break;
                case 'User':
                    this.isUser = true;
                    break;
                case 'Static Resource':
                    this.isStaticResource = true;
                    break;
                case 'Profile':
                    this.isProfile = true;
                    break;
                case 'Named Credential':
                    this.isNamedCredential = true;
                    break;
                case 'Metadata Package':
                    this.isMetadataPackage = true;
                    break;
                case 'Global Value Set':
                    this.isGlobalValueSet = true;
                    break;
                case 'Field Mapping':
                    this.isFieldMapping = true;
                    break;
                case 'Custom Application':
                    this.isCustomApplication = true;
                    break;
                case 'Flow':
                    this.isFlow = true;
                    break;
                case 'Custom Field':
                    this.isCustomField = true;
                    break;
                case 'Validation Rule':
                    this.isValidationRule = true;
                    break;
            }
            // if (this.value === 'lwcDependencies') {
            //     this.isLWC = true;
            //     this.isApexTrigger = false;
            //     this.isApexClass = false;
            // } else if (this.value === 'apexClassesDependencies') {
            //     this.isApexClass = true;
            //     this.isApexTrigger = false;
            //     this.isLWC = false;

            // } else if (this.value === 'apexTriggersDependencies') {
            //     this.isApexTrigger = true;
            //     this.isLWC = false;
            //     this.isApexClass = false;
            // }
        }
        /*AnalyticSnapshot
ApexComponent
ApexPage
AutoResponseRule
BusinessProcess
Community
CompactLayout
ConnectedApp
CspTrustedSite
CustomLabel
CustomMetadata
CustomTab
Dashboard	
Document
DuplicateRule
FlexiPage
HomePageComponent
HomePageLayout
InstalledPackage
Layout
ListView
Queue
QuickAction
RemoteSiteSettingReport
Report
ReportType
Role
SharingRules
SiteDotCom
TopicsForObjects
*/
}