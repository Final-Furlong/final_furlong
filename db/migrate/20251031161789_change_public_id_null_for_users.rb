class ChangePublicIdNullForUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :new_users, :public_id, true
  end
end
