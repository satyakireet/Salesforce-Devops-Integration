import { api, LightningElement, track } from 'lwc';
import getAllJobsOfABranch from '@salesforce/apex/JenkinsCommunication.getAllJobsOfABranch';
import getBuildDetails from '@salesforce/apex/JenkinsCommunication.getBuildDetails';
import getBuildOnConsole from '@salesforce/apex/JenkinsCommunication.getBuildOnConsole';

const COLUMNS = [
    { label: 'Build Number', fieldName: 'number' }
];

export default class TestJenkinsComponent extends LightningElement {
    @api recordId;
    builds = [];
    columns = COLUMNS;
    totalcount;
    lastBuildDetails;
    buildConsoleText;
    buildFileText = "slds-section slds-is-close";
    buildSpinner = true;

    connectedCallback() {
        this.refreshBuildStatus();
    }
    refreshBuildStatus() {
        getAllJobsOfABranch({ branchId: this.recordId }).then(data => {
            let response = JSON.parse(data);
            if (response.builds.length == 0) {
                this.builds = false;
            } else {
                this.builds = response.builds;
                getBuildDetails({ branchId: this.recordId, buildNumber: this.builds[0].number }).then(data => {
                    this.lastBuildDetails = JSON.parse(data);
                    getBuildOnConsole({ branchId: this.recordId, buildNumber: this.builds[0].number }).then(data => {
                        this.buildConsoleText = data;
                    }).catch(err => {
                        console.error(err);
                    });
                    setTimeout(() => {
                        this.buildSpinner = this.lastBuildDetails.building;
                        if (this.buildSpinner) {
                            this.refreshBuildStatus();
                        }
                    }, 1500);

                }).catch(err => {
                    console.error(err);
                });
            }
        }).catch(err => {
            console.error(err);
        });
    }
    handleBuildFileText() {
        if (this.buildFileText == 'slds-section slds-is-open') {
            this.buildFileText = 'slds-section slds-is-close';
            return;
        }
        if (this.buildFileText == 'slds-section slds-is-close') {
            this.buildFileText = 'slds-section slds-is-open';
            return;
        }

    }
}