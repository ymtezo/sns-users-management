require 'sinatra'
require 'sinatra/json'
require 'active_record'
require 'json'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
  end
end

# Database configuration
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/sns_users.db'
)

# Models
class User < ActiveRecord::Base
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'following_id'
  has_many :following, through: :following_relationships, source: :following
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :posts, dependent: :destroy
  
  serialize :interests, coder: JSON
  serialize :attributes_list, coder: JSON
  
  validates :username, presence: true, uniqueness: true
  validates :display_name, presence: true
end

class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'
  
  validates :follower_id, uniqueness: { scope: :following_id }
  validate :cannot_follow_self
  
  private
  
  def cannot_follow_self
    errors.add(:base, 'Cannot follow yourself') if follower_id == following_id
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  
  validates :content, presence: true
end

# Routes

# Users CRUD
get '/api/users' do
  platform = params[:platform] || 'twitter'
  users = User.where(platform: platform).order(created_at: :desc)
  
  json users.map { |user|
    user.attributes.merge(
      following_count: user.following.count,
      followers_count: user.followers.count,
      posts: user.posts.limit(3).map(&:attributes)
    )
  }
end

get '/api/users/:id' do
  user = User.find(params[:id])
  
  json user.attributes.merge(
    following_count: user.following.count,
    followers_count: user.followers.count,
    posts: user.posts.order(created_at: :desc).limit(10).map(&:attributes)
  )
rescue ActiveRecord::RecordNotFound
  status 404
  json({ error: 'User not found' })
end

post '/api/users' do
  data = JSON.parse(request.body.read)
  
  user = User.new(
    platform: data['platform'] || 'twitter',
    username: data['username'],
    display_name: data['display_name'],
    bio: data['bio'],
    interests: data['interests'] || [],
    interest_details: data['interest_details'],
    attributes_list: data['attributes'] || []
  )
  
  if user.save
    # Create sample posts
    2.times do |i|
      user.posts.create(
        content: i == 0 ? '新しいプロジェクトを始めました！' : 'SNSユーザ管理システムについて考えています',
        likes: rand(0..100)
      )
    end
    
    status 201
    json user.attributes.merge(
      following_count: 0,
      followers_count: 0,
      posts: user.posts.map(&:attributes)
    )
  else
    status 422
    json({ errors: user.errors.full_messages })
  end
end

put '/api/users/:id' do
  user = User.find(params[:id])
  data = JSON.parse(request.body.read)
  
  if user.update(
    display_name: data['display_name'] || user.display_name,
    bio: data['bio'] || user.bio,
    interests: data['interests'] || user.interests,
    interest_details: data['interest_details'] || user.interest_details,
    attributes_list: data['attributes'] || user.attributes_list
  )
    json user.attributes.merge(
      following_count: user.following.count,
      followers_count: user.followers.count
    )
  else
    status 422
    json({ errors: user.errors.full_messages })
  end
rescue ActiveRecord::RecordNotFound
  status 404
  json({ error: 'User not found' })
end

delete '/api/users/:id' do
  user = User.find(params[:id])
  user.destroy
  
  status 204
rescue ActiveRecord::RecordNotFound
  status 404
  json({ error: 'User not found' })
end

# Relationships CRUD
get '/api/relationships' do
  relationships = Relationship.includes(:follower, :following).order(created_at: :desc)
  
  json relationships.map { |rel|
    {
      id: rel.id,
      follower: { id: rel.follower.id, username: rel.follower.username, display_name: rel.follower.display_name },
      following: { id: rel.following.id, username: rel.following.username, display_name: rel.following.display_name },
      created_at: rel.created_at
    }
  }
end

post '/api/relationships' do
  data = JSON.parse(request.body.read)
  
  relationship = Relationship.new(
    follower_id: data['follower_id'],
    following_id: data['following_id']
  )
  
  if relationship.save
    status 201
    json relationship.attributes
  else
    status 422
    json({ errors: relationship.errors.full_messages })
  end
end

delete '/api/relationships/:id' do
  relationship = Relationship.find(params[:id])
  relationship.destroy
  
  status 204
rescue ActiveRecord::RecordNotFound
  status 404
  json({ error: 'Relationship not found' })
end

# Posts CRUD
get '/api/posts' do
  posts = Post.includes(:user).order(created_at: :desc).limit(50)
  
  json posts.map { |post|
    post.attributes.merge(
      user: { id: post.user.id, username: post.user.username, display_name: post.user.display_name }
    )
  }
end

post '/api/posts' do
  data = JSON.parse(request.body.read)
  
  post = Post.new(
    user_id: data['user_id'],
    content: data['content'],
    likes: data['likes'] || 0
  )
  
  if post.save
    status 201
    json post.attributes.merge(
      user: { id: post.user.id, username: post.user.username, display_name: post.user.display_name }
    )
  else
    status 422
    json({ errors: post.errors.full_messages })
  end
end

# Health check
get '/health' do
  json({ status: 'ok', timestamp: Time.now })
end
