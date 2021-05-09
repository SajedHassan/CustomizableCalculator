require 'rails_helper'

def get_operator_symbol_by_name(operation_id)
  Operation::BinaryOperationsHelper.supported_operations[operation_id][:symbol]
end

def assert_text_successful_response(first_operand, operation_id, second_operand, result, count, response)
  expect(response).to be_successful
  expect(response.body).to include("Operation: #{first_operand} #{get_operator_symbol_by_name(operation_id)} #{second_operand}")
  expect(response.body).to include("Result: #{result}")
  expect(response.body).to include("Count: #{count}")
end

def mock_post_request_to_create_or_update__and_assert_successful_response(
        first_operand, operation_id, second_operand, result, count, expected_record_count_diff, valid_operation=true)

  expect {
    post operation_binary_operations_create_or_update_path,
         params: { binary_operation: { operation_id: operation_id,
                                       first_operand: first_operand,
                                       second_operand: second_operand }}
  }.to change(Operation::BinaryOperation, :count).by(expected_record_count_diff)

  if valid_operation
    assert_text_successful_response first_operand, operation_id, second_operand, result, count, response
  else
    expect(response).not_to be_successful
  end
end

RSpec.describe "Operation::BinaryOperations", type: :request do

  describe "POST /operation/binary_operations" do

    it "performs a valid addition" do
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :ADD, 2, 3, 1, 1)
    end

    it "performs a valid subtraction" do
      mock_post_request_to_create_or_update__and_assert_successful_response(7, :SUB, 2, 5, 1, 1)
    end

    it "performs a valid multiplication" do
      mock_post_request_to_create_or_update__and_assert_successful_response(7, :MUL, 2, 14, 1, 1)
    end

    it "performs a valid division" do
      mock_post_request_to_create_or_update__and_assert_successful_response(6, :DIV, 2, 3, 1, 1)
    end

    it "performs a valid division with floating point" do
      mock_post_request_to_create_or_update__and_assert_successful_response(4, :DIV, 3, 1.333, 1, 1)
    end

    it "performs a -valid- division by zero" do
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :DIV, 0, :Infinity, 1, 1)
    end

    it "performs duplicate commutative operations" do
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :ADD, 3, 4, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :ADD, 3, 4, 2, 0)
      mock_post_request_to_create_or_update__and_assert_successful_response(3, :ADD, 1, 4, 3, 0)

      mock_post_request_to_create_or_update__and_assert_successful_response(2, :MUL, 3, 6, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(2, :MUL, 3, 6, 2, 0)
      mock_post_request_to_create_or_update__and_assert_successful_response(3, :MUL, 2, 6, 3, 0)
    end

    it "performs duplicate non commutative operations" do
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :SUB, 3, -2, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :SUB, 3, -2, 2, 0)
      mock_post_request_to_create_or_update__and_assert_successful_response(3, :SUB, 1,  2, 1, 1)

      mock_post_request_to_create_or_update__and_assert_successful_response(4, :DIV, 2,   2, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(4, :DIV, 2,   2, 2, 0)
      mock_post_request_to_create_or_update__and_assert_successful_response(2, :DIV, 4, 0.5, 1, 1)
    end

    it "performs operations with on-the-boundaries inputs" do
      mock_post_request_to_create_or_update__and_assert_successful_response(0, :SUB, 0, 0, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(99, :SUB, 99, 0, 1, 1)
      mock_post_request_to_create_or_update__and_assert_successful_response(99, :SUB, 0,  99, 1, 1)
    end

    it "performs operations with non numeric inputs" do
      mock_post_request_to_create_or_update__and_assert_successful_response(1, :SUB, "three", -2, 1, 0, false)
      mock_post_request_to_create_or_update__and_assert_successful_response("three", :SUB, 1, -2, 1, 0, false)
      mock_post_request_to_create_or_update__and_assert_successful_response("three", :SUB, "one", -2, 1, 0, false)

      mock_post_request_to_create_or_update__and_assert_successful_response(1, :NOT_SUPPORTED_OP, 3, -2, 1, 0, false)
    end

    it "performs operations with out of the boundries inputs" do
      mock_post_request_to_create_or_update__and_assert_successful_response(-1, :SUB, 0, -1, 1, 0, false)
      mock_post_request_to_create_or_update__and_assert_successful_response(0, :SUB, -1, 1, 1, 0, false)

      mock_post_request_to_create_or_update__and_assert_successful_response(100, :SUB, 0, 100, 1, 0, false)
    end
  end
end
