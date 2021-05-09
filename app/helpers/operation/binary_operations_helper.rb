module Operation::BinaryOperationsHelper

  # Returns the binary supported operations
  def self.supported_operations
    Operation::BinaryOperation.SUPPORTED_OPERATIONS
  end

  def self.operation_type
    :BINARY_OPERATION
  end

  ################################################################################################
  # Return the config object that's corresponding to the supported BinaryOperations
  #
  # this is used by the UA to build its layout dynamically
  ################################################################################################

  def self.config
    {
      type: operation_type,
      first_operand_fieldName: 'binary_operation[first_operand]',
      second_operand_fieldName: 'binary_operation[second_operand]',
      supported_operations: supported_operations.keys.map do
        |key| { id: key, label: supported_operations[key][:label], symbol: supported_operations[key][:symbol] }
      end
    }
  end
end
