import { api, LightningElement } from 'lwc';
import getUserStoryPath from '@salesforce/apex/InternalController.getUserStoryPath';

export default class UserStoryPath extends LightningElement {
    @api recordId;
    path;
    connectedCallback() {
        getUserStoryPath({userStoryId:this.recordId}).then(response=>{
            this.path = response;
            console.log('Path -'+JSON.stringify(this.path));
        }).catch(error=>{
            console.error(error);
        });
    }
}