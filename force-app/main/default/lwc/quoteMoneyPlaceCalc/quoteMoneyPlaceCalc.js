import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { CalHelper } from "./quoteMoneyPlaceCalcHelper";
import { QuoteCommons } from "c/quoteCommons";
import LENDER_LOGO from "@salesforce/resourceUrl/MoneyPlaceLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteMoneyPlaceCalc extends LightningElement {
  isErrorDisplay = false;
  @track errorMessageList;
  isBusy; // loading
  @api recordId; // Opportunity Id
  @track quoteForm;

  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  // initial data and configs
  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
        this.quoteForm = data;
        this.quoteForm["maxDof"] = CalHelper.handleMaxDOF(
          this.quoteForm["price"]
        );
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Loading...", error, "error");
      })
      .finally(() => {
        this.isBusy = false;
      });
  }

  // lifecycle hook - after rendering all components(child+parent), will triggered
  renderedCallback() {
    QuoteCommons.resetValidateFields(this);
  }

  get logoUrl() {
    return LENDER_LOGO;
  }

  // Combobox options
  get loanTypeOptions() {
    return CalHelper.options.loanTypes;
  }

  get loanProductOptions() {
    return CalHelper.options.loanProducts;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  // realtime displaying the NAF as the last row in the left side
  get netRealtimeNaf() {
    let r = 0.0;
    r += this.quoteForm.price > 0.0 ? this.quoteForm.price : 0;
    r +=
      this.quoteForm.applicationFee > 0.0 ? this.quoteForm.applicationFee : 0;
    r += this.quoteForm.dof > 0.0 ? this.quoteForm.dof : 0;
    return r;
  }

  // Reset
  reset() {
    this.quoteForm = CalHelper.reset();
  }

  // -------------
  // Button events
  // -------------

  // Calculate
  handleCalculate(event) {
    this.isBusy = true;
    CalHelper.calculate(this.quoteForm)
      .then((data) => {
        console.log("@@data:", JSON.stringify(data, null, 2));
        this.quoteForm.commissions = data.commissions;
        displayToast(this, "Calculate", "Done!", "info");
      })
      .catch((error) => {
        this.errorMessageList = error.messages.get(
          QuoteCommons.VALIDATION_OPTIONS.ERROR
        );
        this.isErrorDisplay = this.errorMessageList.length > 0 ? true : false;
        console.error(JSON.stringify(error.messages.get("ERROR"), null, 2));
      })
      .finally(() => {
        this.isBusy = false;
      });
    if (results && Array.isArray(results) && results.length > 0) {
      // this.quoteResult = results[0];
    }
  }

  // Reset function
  handleReset(event) {
    this.reset();
    QuoteCommons.handleHasErrorClassClear(this);
  }

  // handle all field changes according to the type of field
  handleFieldChange(event) {
    console.log(`Changing value for: ${event.target.name}...`);
    const fldName = event.target.name;
    let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
    let v = event.detail ? event.detail.value : "";
    if (fld && fld.type === "number") {
      v = Number(v);
    }
    // casting the string to number
    fldName === "term"
      ? (this.quoteForm[fldName] = parseInt(v))
      : (this.quoteForm[fldName] = v);
    console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));

    // calculate max dof
    if (fldName === "price") {
      this.quoteForm["maxDof"] = CalHelper.handleMaxDOF(event.detail.value);
      this.quoteForm["dof"] = CalHelper.handleMaxDOF(event.detail.value);
    }
  }

  //   /**
  //    * For controlling the footer hide/show
  //    * @param footerElem is not undefined
  //    */
  //   handleSlotFooterChange() {
  //     const footerElem = this.template.querySelector("footer");
  //     if (footerElem) {
  //       footerElem.classList.remove("slds-hide");
  //     }
  //   }
}