class SimpleCalculatorController < ApplicationController

  ################################################################################################
  # This can be used for customizing the simple calculator view depending on some
  # passed url params like the type of the supported operations by the simple calculator
  # to generate an appropriate operation_config object that is used by the view
  # to adjust its layout dynamically.
  #################################################################################################

  def index
    # The config object is constructed using the sent params or a default config object is
    # built, this is used to build the layout of the view dynamically depending on the server
    # supported operations.
    @operation_config =
      if simple_calculator_params.key?(:operations_type)
        SimpleCalculatorHelper.operation_config simple_calculator_params[:operations_type].to_sym
      else
        SimpleCalculatorHelper.operation_config # get default operation config object
      end
  end

  private

  # Only allow a list of trusted parameters through.
  def simple_calculator_params
    params.permit(:operations_type)
  end
end
