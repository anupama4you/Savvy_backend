import getQuotingData from "@salesforce/apex/QuoteController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

const LENDER_QUOTING = "Money Place";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"]
]);

// setting fields refer to the DEFAULT VALUES that showing on th page you open
const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  terms: CommonOptions.terms(12, 84)
};

/**
 *
 * @param {object} quote
 * @returns Returns list of calculation results
 */
const calculate = (quote) =>
  new Promise((resolve, reject) => {
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: new Map()
    };
    // Validate quote
    res.messages = Validations.validate(quote);
    if (
      res.messages &&
      res.messages.get(QuoteCommons.VALIDATION_OPTIONS.ERROR).length !== 0
    ) {
      console.log("--- reject ----- from ----  calculate");
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        amountBaseComm: quote.price
      };

      // Calculate
      console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF:`, JSON.stringify(data, null, 2));
          // Mapping
          res.commissions = QuoteCommons.mapCommissionSObjectToLwc(data);
          resolve(res);
        })
        .catch((error) => {
          let errMsg = res.messages.get(QuoteCommons.VALIDATION_OPTIONS.ERROR);
          if (!errMsg) {
            errMsg = new Array();
          }
          errMsg.push(["calculation", error]);
          res.messages.set(QuoteCommons.VALIDATION_OPTIONS.ERROR, errMsg);
          reject(res);
        });
    }
  });

// Reset the values to default
const reset = () => {
  return {
    loanType: "Purchase",
    loanProduct: "Consumer Loan",
    price: null,
    applicationFee: null,
    maxDof: null,
    dof: null,
    ppsr: null,
    residual: null,
    term: 60,
    monthlyFee: null,
    clientRate: null,
    paymentType: "Arrears",
    commissions: QuoteCommons.resetResults()
  };
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //  const fields = Array.from(QUOTING_FIELDS.values());
    const fields = [
      ...QUOTING_FIELDS.values(),
      ...QuoteCommons.COMMISSION_FIELDS.values()
    ];
    console.log(`@@fields:`, JSON.stringify(fields, null, 2));
    getQuotingData({
      param: { oppId: recordId, fields: fields, calcName: LENDER_QUOTING }
    })
      .then((quoteData) => {
        console.log(`@@SF:`, JSON.stringify(quoteData, null, 2));
        // Mapping Quote's fields
        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(),
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

/**
 * @param {number} value - value of input price/amount
 * @returns max dof for two decimal format
 */
const handleMaxDOF = (value) => {
  var r = 0.0;
  var v = value; //
  if (v < 20000) {
    r = v > 990.0 ? 990.0 : v * 0.1;
  } else if (v < 40000) {
    r = 1690.0;
  } else {
    r = 1990.0;
  }
  return parseFloat(r.toFixed(2));
};

export const CalHelper = {
  options: calcOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  handleMaxDOF: handleMaxDOF
};