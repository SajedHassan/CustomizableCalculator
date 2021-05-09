import React from 'react'
import PropTypes from 'prop-types'
import {
    Alert
} from 'react-bootstrap';
import ResultScreen from "../ResultScreen";
import BinaryOperationsKeyboard from "../keyboards/BinaryOperationsKeyboard";

export default function BinaryCalculator(props) {
    return (
        <div>
            { props.errors.length > 0
                && <Alert variant="danger">
                       { props.errors.map((error, index) => {
                           return <div key={index}>{error}</div>;
                       })}
                   </Alert>
            }

            <BinaryOperationsKeyboard firstOperandDefaultValue={props.firstOperand}
                                      handleFirstOperandChange={props.handleFirstOperandChange}
                                      secondOperandDefaultValue={props.secondOperand}
                                      handleSecondOperandChange={props.handleSecondOperandChange}
                                      binaryOperationConfig={props.operationConfig}
                                      submitDisabled={ props.errors.length > 0
                                                       || props.isWaitingForResponse}
                                      inputDisabled={ props.isWaitingForResponse }
                                      handleOperationClick={props.handleOperationClick}/>

            <ResultScreen result={props.result}/>
        </div>
    );
}

BinaryCalculator.defaultProps = {
    errors: [],
    firstOperand: "",
    secondOperand: "",
    operationConfig: {type: 'NOT_SUPPORTED'},
    isWaitingForResponse: false,
    result: ""
}

BinaryCalculator.propTypes = {
    errors: PropTypes.array,
    firstOperand: PropTypes.string,
    handleFirstOperandChange: PropTypes.func,
    secondOperand: PropTypes.string,
    handleSecondOperandChange: PropTypes.func,
    operationConfig: PropTypes.object,
    isWaitingForResponse: PropTypes.bool,
    handleOperationClick: PropTypes.func,
    result: PropTypes.string
}
