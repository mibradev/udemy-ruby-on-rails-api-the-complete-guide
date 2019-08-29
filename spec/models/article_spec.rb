require 'rails_helper'

RSpec.describe Article, type: :model do
  it "should be valid" do
    expect(FactoryBot.build(:article)).to be_valid
  end

  it "should have title" do
    article = FactoryBot.build(:article, title: "")
    expect(article).not_to be_valid
    expect(article.errors.messages[:title]).to include("can't be blank")
  end

  it "should have content" do
    article = FactoryBot.build(:article, content: "")
    expect(article).not_to be_valid
    expect(article.errors.messages[:content]).to include("can't be blank")
  end

  it "should have slug" do
    article = FactoryBot.build(:article, slug: "")
    expect(article).not_to be_valid
    expect(article.errors.messages[:slug]).to include("can't be blank")
  end

  it "should have unique slug" do
    article = FactoryBot.create(:article)
    invalid_article = FactoryBot.build(:article, slug: article.slug)
    expect(invalid_article).not_to be_valid
    expect(invalid_article.errors.messages[:slug]).to include("has already been taken")
  end
end
