import { api, LightningElement, track } from 'lwc';
//import diff from '@salesforce/resourceUrl/diff';
import getSourceAndTargetBranchNames from '@salesforce/apex/InternalController.getSourceAndTargetBranchNames';
import getUserStoryProject from '@salesforce/apex/InternalController.getUserStoryProject';
import checkCodeCoverage from '@salesforce/apex/InternalController.checkCodeCoverage';
import createPromotion from '@salesforce/apex/InternalController.createPromotion';
import createPullRequest from '@salesforce/apex/GithubCommunication.createPullRequest';
import compareBranches from '@salesforce/apex/GithubCommunication.compareBranches';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class CreatePullRequestComponent extends LightningElement {
    @api recordId;
    projectId;
    baseBranch;
    compareBranch;
    pullRequestMessage;
    pullRequestButton = true;
    mergePullRequestButton = true;
    fileContent = [];
    @track isModalOpen = false;
    @track isCoverageAboveThenLimit = false;
    @track identical = false;
    @track createPromotion = false;

    connectedCallback() {
        checkCodeCoverage({ userStoryId: this.recordId }).then(response=>{
            this.isCoverageAboveThenLimit = response;
        }).catch(error => {
            console.error(error);
        });
        getUserStoryProject({ userStoryId: this.recordId }).then(response=>{
            this.projectId = response;
        }).catch(error => {
            console.error(error);
        });
        getSourceAndTargetBranchNames({ userStoryId: this.recordId }).then(data => {
            this.baseBranch = data[0];
            this.compareBranch = data[1];
            if(data[2] == 'Create Promotion') {
                this.createPromotion = true;
            }
            this.getComaparision();
        }).catch(error => {
            this.createPromotion = false;
            console.error(error);
        });
    };

    // renderedCallback(){
    //     Promise.all([
    //         loadScript(this, diff + '/diff2html/lib-esm/diff2html.js')
    //         //loadStyle(this, diff + 'diff2html-master/src/ui/css/diff2html.css')
    //     ]);
    // }
    handleMessageInput(event) {
        this.pullRequestMessage = event.target.value;
    }
    getComaparision() {
        if (this.baseBranch != null && this.compareBranch != null) {
            
            if (this.baseBranch == this.compareBranch) {
                this.pullRequestButton = true;
            }
            compareBranches({ baseBranch: this.baseBranch, compareBranch: this.compareBranch, projectId:this.projectId }).then(response => {
                //response = JSON.parse(response);
                this.fileContent = response;
                //console.log('Compare Branch - ' + this.fileContent);
                if(response.length == 0) {
                    this.identical = true;
                    this.pullRequestButton = true;
                }
                else{
                    this.identical = false;
                    this.pullRequestButton = false;
                }


            }).catch(error => {
                console.error(error);
            });
        }
    }

    pullRequest() {
        createPullRequest({ baseBranch: this.baseBranch, compareBranch: this.compareBranch, message: this.pullRequestMessage, projectId:this.projectId }).then(response => {
            
            let result = JSON.parse(response);
            console.log('Pull No. - ' + result.number);
            if(this.createPromotion) {
                createPromotion({userStoryId:this.recordId,sourceBranch:this.compareBranch,targetBranch:this.baseBranch,pullNumber:result.number}).then(res=>{
                    if(res) {
                        console.log(JSON.stringify(res));
                    }
                }).catch(error => {
                    console.error(error);
                });
            }
            const evt = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Pull Request Created Successfuly',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.pullRequestButton = true;
            this.mergePullRequestButton = false;
        }).catch(error => {
            console.error(error);
            const evt = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Something is incorrect',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        });
    }

    mergePullRequest(){

    }

    showDiff() {
        this.isModalOpen = true;
    }

    //Method to close modal
    closeModal() {
        this.isModalOpen = false;
    }
}