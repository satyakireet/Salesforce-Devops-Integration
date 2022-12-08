import { LightningElement, track, wire } from 'lwc';
import allProjects from '@salesforce/apex/InternalController.allProjects';
import merge from '@salesforce/apex/GithubCommunication.createMergeForPullNumber';
import close from '@salesforce/apex/GithubCommunication.closeAPullRequest';
import getPulls from '@salesforce/apex/GithubCommunication.getPullRequests';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MergePullRequestsComponent extends LightningElement {
    @track projects = [];
    project;
    @wire(allProjects) getProjects(result) {
        if(result.data) {
            for(const list of result.data) {
                const option = {
                    label : list.Name,
                    value : list.Id
                };
                this.projects = [...this.projects, option];
            }
        } else if (result.error) {
            console.error(result.error);
        }
    }
    @track showRequests = false;

    @track pullRequests;
    mergePullRequestButton = true
    mergeOrClosePullModalButton = false;
    pullNumber;
    sourceBranch;
    targetBranch;
    title;
    mergeProcessing = false;
    refreshing = false;
    getProjectRepoRequests(event) {
        this.project = event.target.value;
        this.showRequests = true;
        this.getPullRequests();
    }

    getPullRequests() {
        this.refreshing = true;
        getPulls({projectId: this.project}).then(resp => {
            resp = JSON.parse(resp);
            this.refreshing = false;
            if (resp.length == 0) {
                this.pullRequests = false;
                return;
            }
            this.pullRequests = resp;
        }).catch(error => {
            console.error(error);
        });
    }

    handlepullrequestMessageInput(event) {
        this.title = event.target.value;
    }
    mergePullRequestModal(event) {
        this.pullNumber = event.target.dataset.pullnumber;
        this.sourceBranch = event.target.dataset.source;
        this.targetBranch = event.target.dataset.target;
        console.log('PN - ' + this.pullNumber);
        this.mergeOrClosePullModalButton = true;
    }
    mergePullRequest() {
        console.log('PN - ' + this.pullNumber);
        console.log('titile - ' + this.title);
        this.mergeProcessing = true;
        merge({ pullNumber: this.pullNumber, title: this.title, projectId:this.project, sourceBranch:this.sourceBranch, targetBranch:this.targetBranch }).then(resp => {
            console.log(resp);
            const successMerge = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Pull request #' + this.pullNumber + ' merged Successfuly.',
                variant: 'success',
            });
            this.mergeProcessing = false;
            this.getPullRequests();
            this.dispatchEvent(successMerge);
            this.closeMergeRequestModal();
        }).catch(error => {
            console.error(error);
            const mergeFail = new ShowToastEvent({
                title: 'Pull Request',
                message: error.message,
                variant: 'error',
            });
            
            this.mergeProcessing = false;
            this.dispatchEvent(mergeFail);
            this.closeMergeRequestModal();
        });
    }

    closeAPullRequest() {
        console.log('CPN - ' + this.pullNumber);
        console.log('titile - ' + this.title);
        
        this.mergeProcessing = true;
        close({ pullNumber: this.pullNumber, title: this.title, projectId:this.project, sourceBranch:this.sourceBranch, targetBranch:this.targetBranch }).then(resp => {
            console.log(resp);
            const closeSuccess = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Pull request #' + this.pullNumber + ' closed Successfuly.',
                variant: 'success',
            });
            this.mergeProcessing = false;
            this.getPullRequests();
            this.dispatchEvent(closeSuccess);
            this.closeMergeRequestModal();
        }).catch(error => {
            console.error(error);
            const closefail = new ShowToastEvent({
                title: 'Pull Request',
                message: error.message,
                variant: 'error',
            });
            this.mergeProcessing = false;
            this.dispatchEvent(closefail);
            this.closeMergeRequestModal();
        });
    }

    closeMergeRequestModal() {
        this.mergeOrClosePullModalButton = false;
        this.pullNumber = undefined;
        this.title = undefined;
    }
}