import {Alert, Col, Row} from "react-bootstrap";
import React from "react";
import BinaryCalculatorContainer from "./BinaryCalculatorContainer";
import PropTypes from "prop-types";

class AbstractCalculator extends React.Component {
    constructor(props) {
        super(props);
    }

    getCalculator() {
        if (this.props.operationConfig.type === 'BINARY_OPERATION') {
            return <BinaryCalculatorContainer operationConfig={this.props.operationConfig}
                                              processingUrl={this.props.processingUrl}
                                              formAuthenticityToken={this.props.formAuthenticityToken}
                                              handleSecondOperandChange={this.props.handleSecondOperandChange}/>;
        }
        else {
            return <Alert variant="danger">
                       <div>The required operations are not supported by the available calculators.</div>
                   </Alert>
        }
    }

    render() {
        return (
            <Row className="h-100 justify-content-center align-items-center">
                <Col lg="8" offset="2" className="well">
                    <h1 className="text-center">Simple Calculator</h1>
                    <hr/>
                    { this.getCalculator() }
                </Col>
            </Row>
        );
    };
}

AbstractCalculator.defaultProps = {
    operationConfig: {type: 'NOT_SUPPORTED'}
}

AbstractCalculator.propTypes = {
    operationConfig: PropTypes.object,
    processingUrl: PropTypes.string,
    formAuthenticityToken: PropTypes.string
}

export default AbstractCalculator
