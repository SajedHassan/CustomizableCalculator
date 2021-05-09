import React from 'react'
import PropTypes from 'prop-types'
import {
    Button,
    Form,
    Row,
    Col
} from 'react-bootstrap';

export default function BinaryOperationsKeyboard(props) {
    return (
        <div>
            <Row>
                <Col md="6">
                    <Form.Control type="text"
                                  placeholder="First operand"
                                  name={props.binaryOperationConfig['first_operand_field_name']}
                                  value={props.firstOperand}
                                  className="operand-field"
                                  disabled={props.inputDisabled}
                                  onChange={props.handleFirstOperandChange}/>
                </Col>
                <Col md="6">
                    <Form.Control type="text"
                                  placeholder="Second operand"
                                  name={props.binaryOperationConfig['second_operand_field_name']}
                                  value={props.secondOperand}
                                  className="operand-field"
                                  disabled={props.inputDisabled}
                                  onChange={props.handleSecondOperandChange}/>
                </Col>
            </Row>
            <hr/>
            <Row>
                {props.binaryOperationConfig['supported_operations'].map((supportedOperation) => {
                    return (
                        <Col key={supportedOperation.id} xs="6" md="3">
                            <Button className="operation-button"
                                    disabled={props.submitDisabled}
                                    onClick={() => {props.handleOperationClick(supportedOperation.id)}}>
                                {supportedOperation.label}
                            </Button>
                        </Col>);
                })}
            </Row>
        </div>
    );
};
