import { api, LightningElement, track, wire } from 'lwc';

import getData from '@salesforce/apex/SaveData.getData'

export default class TestToolingAPI extends LightningElement {
    @track clickedButtonLabel;
    @wire(getData) data;
    handleClick(event) {
        console.log("Get Data" + JSON.stringify(this.data));
        this.data();
    }
}