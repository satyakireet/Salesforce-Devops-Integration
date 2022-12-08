import { LightningElement, track } from 'lwc';
import pipelineimage from '@salesforce/resourceUrl/Pipeline_Image';

export default class PipelineComponent extends LightningElement {

    @track pipelineImage;
    connectedCallback() {
        this.pipelineImage = pipelineimage;
    };

}