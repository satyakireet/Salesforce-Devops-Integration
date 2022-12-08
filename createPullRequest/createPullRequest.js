import { LightningElement, track, wire } from 'lwc';
import allProjects from '@salesforce/apex/InternalController.allProjects';
import getAllBranchesOfProjectRepo from '@salesforce/apex/GithubCommunication.getAllBranchesOfProjectRepo';
import createPullRequest from '@salesforce/apex/GithubCommunication.createPullRequest';
import compareBranches from '@salesforce/apex/GithubCommunication.compareBranches';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreatePullRequest extends LightningElement {
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
    @track showBranches = false;
    @track branches = [];
    @track pullRequests ;
    //branch;
    repo = 'temp';
    baseBranch;
    compareBranch;
    fileContent = [];
    pullRequestMessage;
    pullRequestButton = true;
    creatingPullRequest = false;

    @track isModalOpen = false;
    @track identical = false;

    getProjectRepoBranches(event) {
        this.project = event.target.value;
        getAllBranchesOfProjectRepo({projectId:event.target.value}).then(response => {
            let resp = JSON.parse(response);
            this.showBranches = true;
            //console.log('Response - '+resp);
            resp.forEach(element => {
                this.branches = [...this.branches, { label: element.name, value: element.name }];
            });
        }).catch(error => {
            this.showBranches = false;
            console.error(error);
        });
    }

    connectedCallback() {
        // getAllBranchesOfRepo().then(response => {
        //     let resp = JSON.parse(response);
        //     resp.forEach(element => {
        //         this.branches = [...this.branches, { label: element.name, value: element.name }];
        //     });
        // }).catch(error => {
        //     console.error(error);
        // });
    };
    

    handleMessageInput(event) {
        this.pullRequestMessage = event.target.value;
    }

    handleCompareBranchChange(event) {
        this.compareBranch = event.detail.value;
        this.getComaparision();
    }
    handleBaseBranchChange(event) {
        this.baseBranch = event.detail.value;
        this.getComaparision();
    }

    getComaparision() {
        //if (this.baseBranch != null && this.compareBranch != null && (this.baseBranch != this.compareBranch)) {
        if (this.baseBranch != null && this.compareBranch != null) {
            if (this.baseBranch == this.compareBranch) {
                this.pullRequestButton = true;
            }

            //console.log('Compare Branch - ' + this.baseBranch + this.compareBranch);
            compareBranches({ baseBranch: this.baseBranch, compareBranch: this.compareBranch, projectId:this.project }).then(response => {
                //response = JSON.parse(response);
                this.fileContent = response;
                //console.log('Compare Branch - ' + this.fileContent);
                if (response.length == 0) {
                    this.identical = true;
                    this.pullRequestButton = true;
                }
                else {
                    this.identical = false;
                    this.pullRequestButton = false;
                }

            }).catch(error => {
                console.error(error);
            });
        }
    }
    pullRequest() {
        this.creatingPullRequest = true;
        createPullRequest({ baseBranch: this.baseBranch, compareBranch: this.compareBranch, message: this.pullRequestMessage, projectId:this.project }).then(response => {
            //console.log(response);
            this.creatingPullRequest = false;
            const successPull = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Pull Request Created Successfuly',
                variant: 'success',
            });
            this.dispatchEvent(successPull);
            this.pullRequestButton = true;
            this.refreshForm();
            // this.mergePullRequestButton = false;
        }).catch(error => {
            console.error(error);
            const pullFail = new ShowToastEvent({
                title: 'Pull Request',
                message: 'Something is incorrect',
                variant: 'error',
            });
            this.dispatchEvent(pullFail);
        });
    }
    
    showDiff() {
        this.isModalOpen = true;
    }
    //Method to close modal
    closeModal() {
        this.isModalOpen = false;
    }
    refreshForm(){
        //branch = undefined;
        this.baseBranch = undefined;
        this.compareBranch = undefined;
        this.fileContent = [];
        this.pullRequestMessage = undefined;
        this.pullRequestButton = true;
        this.showBranches = false;
        this.project = null;
    }
}