module Legacy
  class MarkingImage < Record
    self.table_name = "ff_marking_images"
  end
end

# == Schema Information
#
# Table name: ff_marking_images
# Database name: legacy
#
#  id         :integer          not null, primary key
#  image      :string(25)       not null, uniquely indexed => [marking_id]
#  marking_id :integer          not null, uniquely indexed => [image]
#
# Indexes
#
#  marking_id  (marking_id,image) UNIQUE
#

