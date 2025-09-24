module Legacy
  class Alert < Record
    self.table_name = "ff_alerts"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_alerts
#
#  Alert      :text(4294967295) not null
#  Date       :date             not null, indexed
#  Expire     :date             indexed
#  ID         :integer          not null, primary key
#  Newbies    :boolean          default(TRUE), not null
#  NonNewbies :boolean          default(TRUE), not null
#
# Indexes
#
#  Date    (Date)
#  Expire  (Expire)
#

