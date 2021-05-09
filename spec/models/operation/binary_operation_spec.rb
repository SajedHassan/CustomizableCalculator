require 'rails_helper'

require 'rails_helper'

RSpec.describe Operation::BinaryOperation, type: :model do
  it { is_expected.to be_mongoid_document }
end

RSpec.describe Operation::BinaryOperation, type: :model do
  it { is_expected.to have_timestamps }
end

RSpec.describe Operation::BinaryOperation do
  it { is_expected.to have_field(:operation_id).of_type(String) }
  it { is_expected.to have_fields(:first_operand, :second_operand).of_type(Integer) }
  it { is_expected.to have_field(:result).of_type(Float) }
  it { is_expected.to have_field(:count).of_type(Integer).with_default_value_of(1) }
end

RSpec.describe Operation::BinaryOperation do
  it { is_expected.to validate_presence_of(:operation_id) }
  it { is_expected.to validate_presence_of(:first_operand) }
  it { is_expected.to validate_presence_of(:second_operand) }
  it { is_expected.to validate_presence_of(:result) }
  it { is_expected.to validate_presence_of(:count) }

  it { is_expected.to validate_inclusion_of(:operation_id).to_allow(["ADD", "SUB", "MUL", "DIV"]) }

  it {
    is_expected.to validate_numericality_of(:first_operand).to_allow(
      { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }
    )
  }
  it {
    is_expected.to validate_numericality_of(:second_operand).to_allow(
      { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }
    )
  }
  it { is_expected.to validate_numericality_of(:result) }
  it { is_expected.to validate_numericality_of(:count).to_allow(only_integer: true, greater_than_or_equal_to: 1) }
end
