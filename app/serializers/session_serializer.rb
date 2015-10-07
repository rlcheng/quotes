class SessionSerializer < ActiveModel::Serializer
  attributes :id, :oauth_token, :created_at, :updated_at, :user_id
end
