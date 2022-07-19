import { VALIDATION_OPTIONS as OPTIONS } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
const validate = (quote) => {
  const r = new Map();
  var errors = [];
  r.set(OPTIONS.ERROR, errors);
  for (const fieldName in quote) {
    const element = quote[fieldName];
    switch (fieldName) {
      case "loanType":
        break;
      case "loanProduct":
        break;
      case "price":
        if (element < 0 || element === null)
          errors.push({ field: "price", message: "Price is invalid" });
        break;
      case "dof":
        if (element < 0 || element === null)
          errors.push({ field: "dof", message: "DOF is invalid" });
        break;
      case "applicationFee":
        if (element < 0 || element === null)
          errors.push({
            field: "applicationFee",
            message: "Application Fee is invalid"
          });
        break;
      case "residual":
        if (element < 0 || element === null)
          errors.push({
            field: "residual",
            message: "Residual Value is invalid"
          });
        break;
      case "monthlyFee":
        console.log(element);
        if (element < 0 || element === null)
          errors.push({
            field: "monthlyFee",
            message: "Monthly Fee is invalid"
          });
        break;
      case "clientRate":
        if (element <= 0 || element === null)
          errors.push({
            field: "clientRate",
            message: "Client Rate must be a POSITIVE number and cannot be ZERO"
          });
        break;
      default:
        break;
    }
  }

  // if (!quote.clientRate || !quote.clientRate > 0.0) {
  //   errors.push(["clientRate", "Client Rate should not be zero."]);
  // }
  // if (!quote.clientTier || !quote.clientTier.length === 0) {
  //   errors.push(["clientTier", "Please select a tier for your client."]);
  // }
  // console.log("errors:", errors);

  // if (errors.length > 0)
  r.set(OPTIONS.ERROR, errors);
  return r;
};

const Validations = {
  validate: validate
};

export { Validations };