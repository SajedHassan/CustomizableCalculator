class Operation::BinaryOperationsController < ApplicationController
  before_action :set_binary_operation_if_any

  # POST /operation/binary_operations/ or /operation/binary_operations.json/
  def create_or_update
    if @binary_operation
      @binary_operation[:count] += 1
    else
      @binary_operation = Operation::BinaryOperation.new(binary_operation_params)
      # "eval" function could have been called within before_create but
      # ActiveRecord is not loaded for more efficiency with the noSQL DB.
      @binary_operation = Operation::BinaryOperation.eval(@binary_operation)
    end

    respond_to do |format|
      if Operation::BinaryOperation.create_or_update(@binary_operation)
        format.html { render :create_or_update, formats: :text, layout: false, content_type: 'text/plain',
                                                status: (@binary_operation[:count] == 1 ? :created : :ok) }

        format.json { render :create_or_update, status: (@binary_operation[:count] == 1 ? :created : :ok) }
      else
        format.html { render :create_or_update, formats: :text, layout: false, content_type: 'text/plain',
                                                status: :unprocessable_entity }

        format.json { render json: @binary_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Returns any equivalent record in the database that can be used to fetch the result from
  def set_binary_operation_if_any
    @binary_operation = Operation::BinaryOperation.find_equivalent_to(binary_operation_params.to_h)
  end

  # Only allow a list of trusted parameters through.
  def binary_operation_params
    params.require(:binary_operation).permit(:operation_id, :first_operand, :second_operand)
  end
end
