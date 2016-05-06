require 'rails_helper'
include SessionsHelper

RSpec.describe CommentsController, type: :controller do
  let(:other_user) {create(:user)}
  let(:my_topic) {create(:topic)}
  let(:my_user) {create(:user)}
  let(:my_post) {create(:post, topic: my_topic, user: my_user)}
  let!(:my_comment) {Comment.create!(body: 'Comment Body', post: my_post, user: my_user)}

  context "guest" do
    describe "POST create" do
      it "redirects to the sign in view" do
        post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "DELETE destroy" do
      it "redirects to the sign in view" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context "member user doing CRUD on a comment they don't own" do
    before do
      create_session(other_user)
    end

    describe "POST create" do
      it "increases the number of comments by one" do
        expect{ post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}}.to change(Comment, :count).by 1
      end

      it "returns http success" do
        post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}
        expect(response).to have_http_status(:success)
      end
    end

    describe "DELETE destroy" do
      it "does not delete the number of comments" do
        expect{delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id}.to change(Comment, :count).by 0
      end

      it "issues a flash[:alert]" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        expect(flash[:alert]).to be_present
      end

      it "redirects the user to the post show view" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        expect(response).to redirect_to([my_topic, my_post])
      end
    end
  end

  context "member user doing CRUD on their own comment" do
    before do
      create_session(my_user)
    end

    describe "POST create" do
      it "increases the number of comments by one" do
        expect{ post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}}.to change(Comment, :count).by 1
      end

      it "returns http success" do
        post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}
        expect(response).to have_http_status(:success)
      end
    end

    describe "DELETE destroy" do
      it "deletes the comment" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        count = Comment.where({id: my_comment.id}).count
        expect(count).to eq 0
      end

      it "returns http success" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "admin user doing CRUD on a comment they don't own" do
    before do
      other_user.admin!
      create_session(other_user)
    end

    describe "POST create" do
      it "increases the number of comments by one" do
        expect{ post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}}.to change(Comment, :count).by 1
      end

      it "returns http success" do
        post :create, format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph}
        expect(response).to have_http_status(:success)
      end
    end

    describe "DELETE destroy" do
      it "deletes the comment" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        count = Comment.where({id: my_comment.id}).count
        expect(count).to eq 0
      end

      it "returns http success" do
        delete :destroy, format: :js, post_id: my_post.id, id: my_comment.id
        expect(response).to have_http_status(:success)
      end
    end
  end
end
