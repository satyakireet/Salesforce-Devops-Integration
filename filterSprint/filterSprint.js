import { api, LightningElement, track, wire } from 'lwc';

import getSprintDetails from '@salesforce/apex/ExportCSV.getSprintDetails';

const SCOLS = [
    { label: 'Name', fieldName: 'SprintName' },
    { label: 'Project Name', fieldName: 'ProjectName' },
    { label: 'Start Date', fieldName: 'StartDate' },
    { label: 'End Date', fieldName: 'EndDate' },
    { label: 'Progress', fieldName: 'Progress' },
    { label: 'Status', fieldName: 'Status' },
];

export default class FilterSprint extends LightningElement {
    @api recordId;
    column = SCOLS;
    sprintWireData = [];
    isDataAvailable = false;
    lst = [];
    sData;
    sprintlst = [];

    yearOptions;
    @api selectedYearValue = '';

    monthOptions;
    @api selectedMonthValue = '';
    isChecked = false;
    constructor() {
        super();
        this.yearOptions = [

            { label: 'All', value: '' },
            { label: '2025', value: '2025' },
            { label: '2024', value: '2024' },
            { label: '2023', value: '2023' },
            { label: '2022', value: '2022' },
            { label: '2021', value: '2021' },
            { label: '2020', value: '2020' },
            { label: '2019', value: '2019' },

        ];
        this.monthOptions = [
            { label: 'All', value: '' },
            { label: 'Jan', value: '1' },
            { label: 'Feb', value: '2' },
            { label: 'Mar', value: '3' },
            { label: 'Apr', value: '4' },
            { label: 'May', value: '5' },
            { label: 'Jun', value: '6' },
            { label: 'Jul', value: '7' },
            { label: 'Aug', value: '8' },
            { label: 'Sept', value: '9' },
            { label: 'Oct', value: '10' },
            { label: 'Nov', value: '11' },
            { label: 'Dec', value: '12' },
        ];
    }
    @wire(getSprintDetails, { projectId: '$recordId', filterYear: '$selectedYearValue', filterMonth: '$selectedMonthValue' }) sdetail(result) {
        let currentData = [];
        if (result.data) {
            result.data.forEach(row => {
                let sData = {};
                sData.Id = row.Id;
                sData.SprintName = row.Name;
                sData.DaysInSprint = row.Days_In_Sprint__c;
                sData.EndDate = row.End_Date__c;
                sData.Progress = row.Progress__c;
                sData.Active = row.Active__c;
                sData.SprintGoal = row.Sprint_Goal__c;
                sData.StartDate = row.Start_Date__c;
                sData.Status = row.Status__c;
                if (row.Project__c) {
                    sData.ProjectName = row.Project__r.Name;
                }
                currentData.push(sData);
            });
            this.sprintWireData = currentData;
            console.log("Data>>" + JSON.stringify(this.sprintWireData));
            if (this.sprintWireData.length) {
                this.isDataAvailable = true;
            } else {
                this.isDataAvailable = false;
            }
        }
    }
    handleListPagination(event) {
        this.lst = [...event.detail.records];
    }

    handleFilterChange(event) {
        const filterName = event.target.name;
        if (filterName === 'Year Filter') {
            this.selectedYearValue = event.target.value;
            console.log("Year" + this.selectedYearValue);
        } else if (filterName === 'Month Filter') {
            this.selectedMonthValue = event.target.value;
        }
    }
    handleSelect(event) {
        var qs = this.template.querySelector('lightning-datatable');
        var srows = qs.getSelectedRows();
        this.sprintlst = srows;
    }
    handleChange(event) {
        console.log("EVent" + JSON.stringify(event.target));
        this.isChecked = event.target.checked;
        console.log("Checked" + this.isChecked);
    }
}