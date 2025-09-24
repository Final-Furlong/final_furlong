module Legacy
  class UserStyle < Record
    self.table_name = "ff_user_styles"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_user_styles
#
#  Colt       :string(6)        default("00F"), not null
#  Filly      :string(6)        default("F00"), not null
#  FontSize   :string(2)        default("10"), not null
#  Gelding    :string(6)        default("090"), not null
#  ID         :integer          not null, primary key
#  Link       :string(255)      default("text-decoration: none"), not null
#  LinkActive :string(255)      default("text-decoration: none"), not null
#  LinkHover  :string(255)      default("text-decoration: none"), not null
#  Skin       :integer          default(1), not null, indexed, indexed => [User]
#  User       :integer          default(0), not null, uniquely indexed, indexed => [Skin]
#
# Indexes
#
#  Skin    (Skin)
#  User    (User) UNIQUE
#  User_2  (User,Skin)
#

