require 'sinatra'
require 'sinatra/json'
require 'json'
require 'rack/cors'
require_relative 'lib/notion_service'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
  end
end

# Initialize Notion service
def notion_service
  @notion_service ||= begin
    api_key = ENV['NOTION_API_KEY']
    database_id = ENV['NOTION_DATABASE_ID']
    
    unless api_key && database_id
      raise 'NOTION_API_KEY and NOTION_DATABASE_ID environment variables are required'
    end
    
    NotionService.new(api_key, database_id)
  end
end

# Routes

# Users CRUD with Notion
get '/api/notion/users' do
  platform = params[:platform]
  result = notion_service.query_users(platform: platform)
  
  if result[:success]
    json result[:users]
  else
    status 500
    json({ error: result[:error] })
  end
end

post '/api/notion/users' do
  data = JSON.parse(request.body.read)
  
  user_data = {
    username: data['username'],
    display_name: data['display_name'],
    platform: data['platform'] || 'twitter',
    bio: data['bio'],
    interests: data['interests'] || [],
    interest_details: data['interest_details'],
    attributes_list: data['attributes'] || [],
    following_count: 0,
    followers_count: 0
  }
  
  result = notion_service.create_user(user_data)
  
  if result[:success]
    status 201
    json({ notion_id: result[:notion_id], data: user_data })
  else
    status 422
    json({ error: result[:error] })
  end
end

put '/api/notion/users/:notion_id' do
  data = JSON.parse(request.body.read)
  
  updates = {}
  updates[:display_name] = data['display_name'] if data['display_name']
  updates[:bio] = data['bio'] if data['bio']
  updates[:interests] = data['interests'] if data['interests']
  updates[:interest_details] = data['interest_details'] if data['interest_details']
  updates[:attributes_list] = data['attributes'] if data['attributes']
  updates[:following_count] = data['following_count'] if data['following_count']
  updates[:followers_count] = data['followers_count'] if data['followers_count']
  
  result = notion_service.update_user(params[:notion_id], updates)
  
  if result[:success]
    json({ success: true, notion_id: params[:notion_id] })
  else
    status 422
    json({ error: result[:error] })
  end
end

delete '/api/notion/users/:notion_id' do
  result = notion_service.delete_user(params[:notion_id])
  
  if result[:success]
    status 204
  else
    status 422
    json({ error: result[:error] })
  end
end

# Health check
get '/health' do
  json({ status: 'ok', timestamp: Time.now, mode: 'notion' })
end
