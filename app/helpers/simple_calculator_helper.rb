module SimpleCalculatorHelper

  ################################################################################################
  # A helper method that's used to construct the config object for the simple calculator
  # interface
  #
  # the generated config object is used by the view to build it's layout dynamically depending
  # on the server supported operations
  ################################################################################################

  def self.operation_config(type = Operation::BinaryOperationsHelper.operation_type)
    case type
    when Operation::BinaryOperationsHelper.operation_type
      Operation::BinaryOperationsHelper.config
    else
      { type: 'NOT_SUPPORTED' }
    end
  end
end
