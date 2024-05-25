class AddClientIdToGoogleAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :google_accounts, :client_id, :string
  end
end
