# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  number     :string(255)
#  date       :date
#  rep_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Order do
  pending "add some examples to (or delete) #{__FILE__}"
end
