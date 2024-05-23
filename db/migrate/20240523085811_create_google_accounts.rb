class CreateGoogleAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :google_accounts do |t|
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
