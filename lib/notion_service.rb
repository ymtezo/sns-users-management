require 'httparty'
require 'json'

# Notion Database Integration for SNS User Management
class NotionService
  include HTTParty
  base_uri 'https://api.notion.com/v1'
  
  def initialize(api_key, database_id)
    @api_key = api_key
    @database_id = database_id
    @headers = {
      'Authorization' => "Bearer #{@api_key}",
      'Notion-Version' => '2022-06-28',
      'Content-Type' => 'application/json'
    }
  end
  
  # Create user in Notion
  def create_user(user)
    body = {
      parent: { database_id: @database_id },
      properties: {
        'Username' => { title: [{ text: { content: user[:username] } }] },
        'Display Name' => { rich_text: [{ text: { content: user[:display_name] } }] },
        'Platform' => { select: { name: user[:platform] || 'Twitter' } },
        'Bio' => { rich_text: [{ text: { content: user[:bio] || '' } }] },
        'Interests' => { multi_select: (user[:interests] || []).map { |i| { name: i } } },
        'Interest Details' => { rich_text: [{ text: { content: user[:interest_details] || '' } }] },
        'Attributes' => { multi_select: (user[:attributes_list] || []).map { |a| { name: a } } },
        'Following Count' => { number: user[:following_count] || 0 },
        'Followers Count' => { number: user[:followers_count] || 0 }
      }
    }
    
    response = self.class.post('/pages', headers: @headers, body: body.to_json)
    
    if response.success?
      { success: true, notion_id: response['id'], data: response }
    else
      { success: false, error: response.body }
    end
  end
  
  # Query users from Notion
  def query_users(platform: nil)
    body = {
      filter: platform ? {
        property: 'Platform',
        select: { equals: platform.capitalize }
      } : nil
    }.compact
    
    response = self.class.post("/databases/#{@database_id}/query", 
                                headers: @headers, 
                                body: body.to_json)
    
    if response.success?
      users = response['results'].map { |page| parse_user_page(page) }
      { success: true, users: users }
    else
      { success: false, error: response.body }
    end
  end
  
  # Update user in Notion
  def update_user(notion_id, updates)
    properties = {}
    
    properties['Display Name'] = { rich_text: [{ text: { content: updates[:display_name] } }] } if updates[:display_name]
    properties['Bio'] = { rich_text: [{ text: { content: updates[:bio] } }] } if updates[:bio]
    properties['Interests'] = { multi_select: (updates[:interests] || []).map { |i| { name: i } } } if updates[:interests]
    properties['Interest Details'] = { rich_text: [{ text: { content: updates[:interest_details] } }] } if updates[:interest_details]
    properties['Attributes'] = { multi_select: (updates[:attributes_list] || []).map { |a| { name: a } } } if updates[:attributes_list]
    properties['Following Count'] = { number: updates[:following_count] } if updates[:following_count]
    properties['Followers Count'] = { number: updates[:followers_count] } if updates[:followers_count]
    
    body = { properties: properties }
    
    response = self.class.patch("/pages/#{notion_id}", 
                                 headers: @headers, 
                                 body: body.to_json)
    
    if response.success?
      { success: true, data: response }
    else
      { success: false, error: response.body }
    end
  end
  
  # Delete user from Notion (archive)
  def delete_user(notion_id)
    body = { archived: true }
    
    response = self.class.patch("/pages/#{notion_id}", 
                                 headers: @headers, 
                                 body: body.to_json)
    
    if response.success?
      { success: true }
    else
      { success: false, error: response.body }
    end
  end
  
  private
  
  def parse_user_page(page)
    props = page['properties']
    
    {
      notion_id: page['id'],
      username: get_title_text(props['Username']),
      display_name: get_rich_text(props['Display Name']),
      platform: get_select(props['Platform']),
      bio: get_rich_text(props['Bio']),
      interests: get_multi_select(props['Interests']),
      interest_details: get_rich_text(props['Interest Details']),
      attributes_list: get_multi_select(props['Attributes']),
      following_count: get_number(props['Following Count']),
      followers_count: get_number(props['Followers Count']),
      created_at: page['created_time'],
      updated_at: page['last_edited_time']
    }
  end
  
  def get_title_text(prop)
    return '' unless prop && prop['title'] && prop['title'][0]
    prop['title'][0]['text']['content']
  end
  
  def get_rich_text(prop)
    return '' unless prop && prop['rich_text'] && prop['rich_text'][0]
    prop['rich_text'][0]['text']['content']
  end
  
  def get_select(prop)
    return nil unless prop && prop['select']
    prop['select']['name']
  end
  
  def get_multi_select(prop)
    return [] unless prop && prop['multi_select']
    prop['multi_select'].map { |item| item['name'] }
  end
  
  def get_number(prop)
    return 0 unless prop && prop['number']
    prop['number']
  end
end

# Example usage (commented out):
# notion_service = NotionService.new(
#   ENV['NOTION_API_KEY'],
#   ENV['NOTION_DATABASE_ID']
# )
#
# # Create user
# result = notion_service.create_user({
#   username: 'test_user',
#   display_name: 'Test User',
#   platform: 'twitter',
#   bio: 'This is a test user',
#   interests: ['Ruby', 'Rails', 'API'],
#   interest_details: 'Interested in backend development',
#   attributes_list: ['Engineer', 'Backend']
# })
#
# # Query users
# users = notion_service.query_users(platform: 'twitter')
