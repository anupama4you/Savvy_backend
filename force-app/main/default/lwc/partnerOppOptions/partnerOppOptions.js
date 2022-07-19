import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import STATUS_FIELD from "@salesforce/schema/Custom_Opportunity__c.Status__c";
import PARTNER_EXTERNAL_FIELD from "@salesforce/schema/Custom_Opportunity__c.Partner_Is_External__c";
import myEquifaxIcon from "@salesforce/resourceUrl/EquifaxIcon";
import myVDIcon from "@salesforce/resourceUrl/VDIcon";
import getOppQuoting from "@salesforce/apex/PartnerCommunityController.getOppQuoting";

const fields = [NAME_FIELD, STATUS_FIELD, PARTNER_EXTERNAL_FIELD];
export default class PartnerOppOptions extends NavigationMixin(LightningElement) {
  @api recordId;
  appUrl;
  @track record;
  @track error;
  @track displayComp = false;
  @track showNewTaskForm = false;
  @track quoting;

  equifaxIcon = myEquifaxIcon + "#equifax";
  vdIcon = myVDIcon + "#vd";

  // Links
  uploadUrl;
  equifaxUrl;
  emailUrl;
  vdUrl;
  smsUrl;

  @wire(getRecord, { recordId: "$recordId", fields })
  wireRecord({ error, data }) {
    // console.log (`wiring...`);
    if (data) {
      this.record = data;
      this.error = undefined;
      if (
        document.title === "[Sales Tools]" ||
        document.title === "[Quoting Tools]" ||
        document.title === "[YTD]" ||
        document.title === "[Servicing]" ||
        document.title === "[Upload Files]" ||
        document.title === "[Asset]" ||
        document.title === "[Send Email]"
      ) {
        document.title = `${this.oppName} ${document.title}`;
      }
    } else if (error) {
      this.error = error;
      this.record = undefined;
    }
    // console.log(JSON.stringify(this.record));
    // console.log(JSON.stringify(this.error));
    // console.log(
    //   `Record id: ${this.recordId} [${this.oppName}] > ${document.title}`
    // );
  }

  @wire(getOppQuoting, { oppId: "$recordId", fields: ["Id", "Name"] })
  wireQuoting({ error, data }) {
    // console.log(`wiring quoting...`);
    if (data) {
      // console.log(JSON.stringify(data, null, 2));
      this.quoting = data;
    } else if (error) {
      console.error(error);
      this.quoting = undefined;
    }
  }

  connectedCallback() {
    // console.log(`this.recordId: ` + this.recordId);
    if (this.recordId && this.recordId != null && this.recordId !== "null") {
      this.displayComp = true;

      let pageRef = this.buildPageRef("partnerConsole__c",{selCmp:'uploadComponent'});
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.uploadUrl = url;
        })
        .catch((err) => console.error(err));

      pageRef = this.buildPageRef("partnerConsole__c",{selCmp:'vedaComponent'});
      //pageRef = this.buildPageRef("Equifax__c");
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.equifaxUrl = url;
        })
        .catch((err) => console.error(err));

      pageRef = this.buildPageRef("partnerConsole__c",{selCmp:'emailComponent'});
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.emailUrl = url;
        })
        .catch((err) => console.error(err));

      pageRef = this.buildPageRef("Send_SMS__c");
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.smsUrl = url;
        })
        .catch((err) => console.error(err));

      pageRef = this.buildPageRef("partnerConsole__c", {selCmp:'vehicleDirectComponent'});
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.vdUrl = url;
        })
        .catch((err) => console.error(err));
    }
  }

  get oppName() {
    return getFieldValue(this.record, NAME_FIELD);
  }

  buildPageRef(pageName, params) {
    let myState = {
      recordId: this.recordId,
      oppName: this.oppName
    };
    if (params) {
      myState = Object.assign(myState, params);
    }
    return {
      type: "comm__namedPage",
      attributes: {
        name: pageName
      },
      state: myState
    };
  }

  handleNewTaskClick(event) {
    event.preventDefault();
    // console.log(`Click on New Task`);
    this.showNewTaskForm = true;
  }

  displayOptionToast(name) {
    this.displayToast(
      `${name} button Click`,
      `Functionality not implemented yet!`,
      "warning"
    );
  }

  displayToast(title, message, variant) {
    const evt = new ShowToastEvent({
      title: `${title}`,
      message: `${message}`,
      variant: `${variant ? variant : "info"}`
    });
    this.dispatchEvent(evt);
  }

  closeNewTaskForm() {
    this.showNewTaskForm = false;
  }
}