require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    let(:comment) { FactoryBot.build(:comment) }

    it "is valid" do
      expect(comment).to be_valid
    end

    it "have content" do
      comment.content = nil
      expect(comment).not_to be_valid
      expect(comment.errors.messages[:content]).to include("can't be blank")
    end

    it "have article" do
      comment.article = nil
      expect(comment).not_to be_valid
      expect(comment.errors.messages[:article]).to include("must exist")
    end

    it "have user" do
      comment.user = nil
      expect(comment).not_to be_valid
      expect(comment.errors.messages[:user]).to include("must exist")
    end
  end
end
