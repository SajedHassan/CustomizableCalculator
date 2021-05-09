class Operation::BinaryOperation

  ################################################################################################
  # The model fields
  ################################################################################################

  include Mongoid::Document
  include Mongoid::Timestamps
  field :operation_id, type: String
  field :first_operand, type: Integer
  field :second_operand, type: Integer
  field :result, type: Float
  field :count, type: Integer, default: 1

  ################################################################################################
  # All supported binary operations.
  #
  # !! IMPORTANT !!
  #
  # To add a new operation, just append an entry to this object and that's it.
  # You DON NOT even need to update the VIEW, all needed configurations are
  # constructed dynamically from this map -@@SUPPORTED_OPERATIONS- and sent to the UA.
  ################################################################################################

  @@SUPPORTED_OPERATIONS = {
    ADD: { label: :Sum, symbol: :+, commutative?: true, proc: proc do |a, b| a + b end },
    SUB: { label: :Difference, symbol: :-, commutative?: false, proc: proc do |a, b| a - b end },
    MUL: { label: :Multiplication, symbol: :*, commutative?: true, proc: proc do |a, b| a * b end },
    DIV: { label: :Division, symbol: :/, commutative?: false, proc: proc do |a, b| a.to_f / b end }
  }.freeze
  mattr_accessor :SUPPORTED_OPERATIONS

  ################################################################################################
  # The model fields' validations
  ################################################################################################

  validates_presence_of :operation_id, :first_operand, :second_operand, :result, :count
  validates_inclusion_of :operation_id, in: @@SUPPORTED_OPERATIONS.keys.map { |key| key.to_s }
  validates_numericality_of :count, only_integer: true, greater_than_or_equal_to: 1
  validates_numericality_of :result
  validates(
    :first_operand,
    :second_operand,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than: 100
    }
  )

  ################################################################################################
  # Main logic
  ################################################################################################

  class << self
    # Searches the DB for an equivalent operation to fetch its result
    def find_equivalent_to(binary_operation)
      isNeutralized = neutralize_commutativity(binary_operation)
      operation_record = Operation::BinaryOperation.where(binary_operation).take(1).first # No SQL injections
      deneutralize_commutativity(operation_record) if operation_record && isNeutralized
      operation_record
    end

    # Evaluates the operation and append its result if the operation is supported
    def eval(binary_operation)
      # check if the operation is not supported
      return binary_operation unless @@SUPPORTED_OPERATIONS.key?(binary_operation[:operation_id].to_sym)

      binary_operation[:result] = @@SUPPORTED_OPERATIONS[binary_operation[:operation_id].to_sym][:proc]
                                    .call(binary_operation[:first_operand], binary_operation[:second_operand])
      binary_operation
    end

    # Creates a new operation-record in the DB or update the current record if already exists
    def create_or_update(binary_operation)
      isNeutralized = neutralize_commutativity(binary_operation)
      # save will perform as upsert due to the _id field inclusion
      # besides taking care of timestamps fields creating and updating
      isUpserted = binary_operation.save
      deneutralize_commutativity(binary_operation) if isNeutralized
      isUpserted
    end

    private

    # Rearrange operands to have the smallest operand first ONLY for COMMUTATIVE operations
    # to make it easier for searching the commutative operations

    def neutralize_commutativity(binary_operation)
      # check if the operation is not supported
      return false unless @@SUPPORTED_OPERATIONS.key?(binary_operation[:operation_id].to_sym)

      if @@SUPPORTED_OPERATIONS[binary_operation[:operation_id].to_sym][:commutative?] &&
        binary_operation[:first_operand] > binary_operation[:second_operand]

        (binary_operation[:first_operand], binary_operation[:second_operand] = binary_operation[:second_operand],
                                                                               binary_operation[:first_operand])
        return true
      end
      false
    end

    def deneutralize_commutativity(binary_operation)
      # check if the operation is not supported
      return false unless @@SUPPORTED_OPERATIONS.key?(binary_operation[:operation_id].to_sym)

      if @@SUPPORTED_OPERATIONS[binary_operation[:operation_id].to_sym][:commutative?] &&
        binary_operation[:first_operand] < binary_operation[:second_operand]

        (binary_operation[:first_operand], binary_operation[:second_operand] = binary_operation[:second_operand],
          binary_operation[:first_operand])
        return true
      end
      false
    end
  end
end
