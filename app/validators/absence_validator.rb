class AbsenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, 'must be blank' unless value.blank?
  end
end