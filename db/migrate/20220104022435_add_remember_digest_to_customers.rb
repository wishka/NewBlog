class AddRememberDigestToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :remember_digest, :string
  end
end
