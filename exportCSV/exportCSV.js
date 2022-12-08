import { api, LightningElement, track, wire } from 'lwc';

import getProjectDetails from '@salesforce/apex/ExportCSV.getProjectDetails';
import getSprintDetail from '@salesforce/apex/ExportCSV.getSprintDetail';
import getSprintDetails from '@salesforce/apex/ExportCSV.getSprintDetails';
import getUserStoryDetails from '@salesforce/apex/ExportCSV.getUserStoryDetails';
import getUserStorySprints from '@salesforce/apex/ExportCSV.getUserStorySprints';
import getAllUserStoryWithoutSprints from '@salesforce/apex/ExportCSV.getAllUserStoryWithoutSprints';

export default class ExportCSV extends LightningElement {

    @api recordId;

    @track xlsHeader = []; // store all the headers of the the tables
    @track workSheetNameList = []; // store all the sheets name of the the tables
    @track xlsData = []; // store all tables data
    @track filename = "Project_Report.xlsx"; // Name of the file

    projectData = []; // used only for storing Project table
    sprintData = []; // used only for storing Sprint table
    userData = []; // used only for storing User table
    sprintListData = [];
    userListData = [];
    uSWithoutSprints = [];

    projectHeader = [];
    sprintHeader = [];
    sprintListHeader = [];
    userHeader = [];
    userListHeader = [];

    @api selectedMonthValue;
    @api selectedYearValue;

    @api sprintlst;
    @api sprintWireData;

    uniqueSprint = [];
    sprintWireId = [];

    @api isChecked;

    // formating the data to send as input to  xlsxMain component
    xlsFormatter(data, sheetName) {
        let Header = Object.keys(data[0]);
        if (window.UndefinedVariable) {
            Object.assign(window.UndefinedVariable, {})
        }
        this.xlsHeader.push(Header);
        this.workSheetNameList.push(sheetName);
        this.xlsData.push(data);
    }

    // calling the download function from xlsxMain.js 
    sprintList() {
        getSprintDetail({ projectId: this.recordId, sprintIds: this.uniqueSprint })
            .then(result => {
                if (result && result.length) {
                    this.sprintListHeader = Object.keys(result[0]);
                    this.sprintListData = [...this.sprintListData, ...result];
                    console.log("Sprint List Data:>>" + JSON.stringify(this.sprintListData));
                    this.xlsFormatter(result, "Related Filtered Sprints List");
                }

            })
            .catch(error => {
                console.error(error);
            });
    }
    sprint() {
        //apex call for bringing the SprintList data  
        getSprintDetails({ projectId: this.recordId, filterYear: this.selectedYearValue, filterMonth: this.selectedMonthValue })
            .then(result => {
                if (result && result.length) {
                    this.sprintHeader = Object.keys(result[0]);
                    this.sprintData = [...this.sprintData, ...result];
                    console.log("Sprint Data:>>" + JSON.stringify(this.sprintData));
                    this.xlsFormatter(result, "Related Sprints");
                }
            })
            .catch(error => {
                console.error(error);
            });
    }
    userStorySprint() {
        //apex call for bringing the User Story data  
        getUserStorySprints({ sprintIds: this.uniqueSprint })
            .then(result => {
                if (result && result.length) {
                    this.userListHeader = Object.keys(result[0]);
                    this.userListData = [...this.userListData, ...result];
                    console.log("User List Data:>>" + JSON.stringify(this.userListData));
                    this.xlsFormatter(result, "Related User Story List");
                }

            })
            .catch(error => {
                console.error(error);
            });
    }
    userStory() {
        //apex call for bringing the User Story data  
        getUserStoryDetails({ sprintIds: this.sprintWireId })
            .then(result => {
                if (result && result.length) {
                    this.userHeader = Object.keys(result[0]);
                    this.userData = [...this.userData, ...result];
                    console.log("User Data:>>" + JSON.stringify(this.userData));
                    this.xlsFormatter(result, "Related User Story");
                }

            })
            .catch(error => {
                console.error(error);
            });
    }
    project() {
        //apex call for bringing the Project data  
        getProjectDetails({ projectId: this.recordId })
            .then(result => {
                if (result && result.length) {
                    this.projectHeader = Object.keys(result[0]);
                    this.projectData = [...this.projectData, ...result];
                    console.log("Project Data:>>" + JSON.stringify(this.projectData));
                    this.xlsFormatter(result, "Projects");
                }

            })
            .catch(error => {
                console.error(error);
            });
    }
    userStoryWithoutSprints() {
        //apex call for bringing the UserStoryWithoutSprints data  
        getAllUserStoryWithoutSprints({ projectId: this.recordId })
            .then(result => {
                if (result && result.length) {
                    this.uSWithoutSprintsHeader = Object.keys(result[0]);
                    this.uSWithoutSprints = [...this.uSWithoutSprints, ...result];
                    console.log("UserStory Without Sprints Data:>>" + JSON.stringify(this.uSWithoutSprints));
                    this.xlsFormatter(result, "UserStory Without Sprints");
                }

            })
            .catch(error => {
                console.error(error);
            });
    }

    download() {
        var tempString = '';
        this.sprintWireData.forEach(element => {
            this.sprintWireId.push(element.Id);
        });
        console.log("Sprint Id" + JSON.stringify(this.sprintWireId));
        console.log("IS CHecked" + this.isChecked);

        this.sprintlst.forEach(element => {
            this.uniqueSprint.push(element.Id);
        });
        console.log("Unique Array" + JSON.stringify(this.uniqueSprint));

        if (this.uniqueSprint.length) {
            this.project();
            this.sprintList();
            this.userStorySprint();
            if (this.isChecked == true) {
                this.userStoryWithoutSprints();
            }

        } else if (this.sprintWireId.length) {
            this.project();
            this.sprint();
            this.userStory();
            if (this.isChecked == true) {
                this.userStoryWithoutSprints();
            }

        }
        this.template.querySelector("c-xlsx-main").download();
        console.log("Success Download");
    }
}