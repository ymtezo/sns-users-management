require 'active_record'

# Database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/sns_users.db'
)

# Create tables
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists? :users
    create_table :users do |t|
      t.string :platform, null: false, default: 'twitter'
      t.string :username, null: false
      t.string :display_name, null: false
      t.text :bio
      t.text :interests
      t.text :interest_details
      t.text :attributes_list
      t.timestamps
    end
    
    add_index :users, :username, unique: true
    add_index :users, :platform
  end
  
  unless ActiveRecord::Base.connection.table_exists? :relationships
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :following_id, null: false
      t.timestamps
    end
    
    add_index :relationships, [:follower_id, :following_id], unique: true
    add_index :relationships, :follower_id
    add_index :relationships, :following_id
  end
  
  unless ActiveRecord::Base.connection.table_exists? :posts
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.text :content, null: false
      t.integer :likes, default: 0
      t.timestamps
    end
    
    add_index :posts, :user_id
    add_index :posts, :created_at
  end
end

puts "Database tables created successfully!"
