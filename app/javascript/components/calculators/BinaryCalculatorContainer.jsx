import React from 'react'
import axios from 'axios';
import PropTypes from 'prop-types'
import BinaryCalculator from "./BinaryCalculator";

class BinaryCalculatorContainer extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            errors: [],
            firstOperand: "",
            secondOperand: "",
            result: "",
            isWaitingForResponse: false
        };

        this.handleFirstOperandChange = this.handleFirstOperandChange.bind(this);
        this.handleSecondOperandChange = this.handleSecondOperandChange.bind(this);
        this.handleOperationClick = this.handleOperationClick.bind(this);
    }

    handleFirstOperandChange(e) {
        this.handleOperandChange('firstOperand', e.target.value);
    }

    handleSecondOperandChange(e) {
        this.handleOperandChange('secondOperand', e.target.value);
    }

    getFormFields() {
        return { firstOperand: this.state.firstOperand, secondOperand: this.state.secondOperand };
    }

    handleOperandChange(currentOperand, input) {
        let formFields = this.getFormFields();
        formFields[currentOperand] = input;

        this.validateInput(formFields)
            .then(() => {
                this.setState({ errors: [], [currentOperand]: input, result: "" });
            })
            .catch((errors) => {
                this.setState({ errors: errors, [currentOperand]: input, result: "" });
            });
    }

    validateInput(formFields) {
        return new Promise( (resolve, reject) => {
            const errors = new Set();
            for (const fieldValue of Object.values(formFields)) {
                if (! this.isInteger(fieldValue) || ! this.isInRange(Number(fieldValue), 0, true, 100, false)) {
                    errors.add("All operands must be non-negative integers less than 100.");
                }
                // add other validations here if needed
            }

            if (errors.size == 0) {
                resolve();
            }
            else {
                reject([...errors]);
            }
        });
    }

    isInteger(input) {
        var num = Math.floor(Number(input));
        return num !== Infinity && String(num) === input;
    }

    hasLowerBound(number, lowerBound, includeLowerBound) {
        return includeLowerBound ? number >= lowerBound : number > lowerBound;
    }

    hasUpperBound(number, upperBound, includeUpperBound) {
        return includeUpperBound ? number <= upperBound : number < upperBound;
    }

    isInRange(number, lowerBound, includeLowerBound, upperBound, includeUpperBound) {
        return this.hasLowerBound(number, lowerBound, includeLowerBound)
            && this.hasUpperBound(number, upperBound, includeUpperBound);
    }

    handleOperationClick(operationId) {
        this.validateInput(this.getFormFields())
            .then(() => {
                this.setState({ errors: []}, this.submitOperation(operationId));
            })
            .catch((errors) => {
                this.setState({ errors: errors});
            });
    }

    submitOperation(operationId) {
        this.setState({ isWaitingForResponse: true, result: "Loading results"  }, () => {
             axios.post(this.props.processingUrl,
                        { authenticity_token: this.props.formAuthenticityToken, // avoid CSRF attacks
                          operation_id: operationId,
                          first_operand: Number(this.state.firstOperand),
                          second_operand: Number(this.state.secondOperand) })
                 .then((response) => {
                     this.setState({ result: response.data, isWaitingForResponse: false });
                 })
                 .catch((error) => {
                     this.setState({ result: this.getErrorMessage(error),
                                     isWaitingForResponse: false });
                 })
        });
    }

    getErrorMessage(error) {
        if (error.response) {
            // The request was made and the server responded with a status code
            // that falls out of the range of 2xx
            return  error.response.data;
        } else if (error.request) {
            // The request was made but no response was received
            return error.request;
        } else {
            // Something happened in setting up the request that triggered an Error
            return error.message;
        }
    }

    render() {
        return (
            <BinaryCalculator operationConfig={this.props.operationConfig}
                              firstOperand={this.state.firstOperand}
                              handleFirstOperandChange={this.handleFirstOperandChange}
                              secondOperand={this.state.secondOperand}
                              handleSecondOperandChange={this.handleSecondOperandChange}
                              errors={this.state.errors}
                              isWaitingForResponse={this.state.isWaitingForResponse}
                              handleOperationClick={this.handleOperationClick}
                              result={this.state.result}/>
        );
    }
}

BinaryCalculatorContainer.defaultProps = {
    operationConfig: {type: 'NOT_SUPPORTED'}
}

BinaryCalculatorContainer.propTypes = {
    operationConfig: PropTypes.object,
    processingUrl: PropTypes.string,
    formAuthenticityToken: PropTypes.string
}

export default BinaryCalculatorContainer