Sequel.migration do
  change do
    create_table(:authentications) do
      primary_key :id
      column :email, 'citext', null: false, unique: true
      column :password_digest,      String,   null: false
      column :user_id, Integer
      column :phone_number, Float, null: false
      column :login, String, null: false
      column :authentication_token, String, null: false, unique: true
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end