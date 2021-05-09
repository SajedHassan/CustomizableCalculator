import React from 'react'
import PropTypes from 'prop-types'
import {
    Form,
    Row,
    Col
} from 'react-bootstrap';

export default function ResultScreen(props) {
    return (
        <Row>
            <Col>
                <Form.Control as="textarea"
                              readOnly
                              placeholder="Operation result area"
                              name="binary_operation[result]"
                              value={props.result}
                              rows={4}/>
            </Col>
        </Row>
    );
}

ResultScreen.defaultProps = {
    result: ""
}

ResultScreen.propTypes = {
    result: PropTypes.string
}
