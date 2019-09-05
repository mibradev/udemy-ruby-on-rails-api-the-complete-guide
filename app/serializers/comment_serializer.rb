class CommentSerializer < ApplicationSerializer
  set_type :comments
  attributes :content

  has_one :article
  has_one :user
end
