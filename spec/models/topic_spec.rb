require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topic) {create(:topic)}

  it {is_expected.to have_many(:posts)}
  it {is_expected.to have_many(:labelings)}
  it {is_expected.to have_many(:labels).through(:labelings)}

  describe "attributes" do
    it "has name and description attributes" do
      expect(topic).to have_attributes(name: topic.name, description: topic.description)
    end

    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end

  describe "scope" do
    before do
      @public_topic = create(:topic)
      @private_topic = create(:topic, public: false)
    end

    describe "visible_to(user)" do
      it "returns all topics if the user is present" do
        user = build(:user)
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end

      it "returns only public topics if the user is nil" do
        expect(Topic.visible_to(nil)).to eq([@public_topic])
      end
    end

    describe "publicly_viewable" do
      it "returns all the public topics" do
        expect(Topic.publicly_viewable).to eq([@public_topic])
      end
    end

    describe "privately_viewable" do
      it "returns all the private topics" do
        expect(Topic.privately_viewable).to eq([@private_topic])
      end
    end
  end
end
