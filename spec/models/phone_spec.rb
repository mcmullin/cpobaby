# == Schema Information
#
# Table name: phones
#
#  id             :integer          not null, primary key
#  number         :string(10)
#  extension      :string(5)
#  country_code   :string(4)
#  description    :string(255)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Phone do
  pending "add some examples to (or delete) #{__FILE__}"
end
