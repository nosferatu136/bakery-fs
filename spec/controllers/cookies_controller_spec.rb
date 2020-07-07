require 'spec_helper'

describe CookiesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:oven) { user.ovens.first }

  describe 'GET new' do
    let(:the_request) { get :new, params: { oven_id: oven.id } }

    context "when not authenticated" do
      before { sign_in nil }

      it "blocks access" do
        the_request
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "allows access" do
        the_request
        expect(response).to_not be_a_redirect
      end

      context "when a valid oven is supplied" do
        it "assigns @oven" do
          the_request

          expect(assigns(:oven)).to eq(oven)
        end

        it "assigns a new @cookie" do
          the_request

          cookie = assigns(:cookie)
          expect(cookie).to_not be_persisted
          expect(cookie.storage).to eq(oven)
        end
      end

      context "when an invalid oven is supplied" do
        let(:oven) { FactoryGirl.create(:oven) }

        it "is not successful" do
          expect {
            the_request
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'POST create' do
    let(:the_request) { post :create, params: { oven_id: oven.id, cookie: cookie_params } }
    let(:cookie_params) {
      {
        fillings: 'Vanilla',
      }
    }

    context "when not authenticated" do
      before { sign_in nil }

      it "blocks access" do
        the_request
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "allows access" do
        expect {
          the_request
        }.to_not raise_error
      end

      context "when a valid oven is supplied" do
        let(:new_cookie) { Cookie.last }

        it "creates a cookie for that oven" do
          expect {
            the_request
          }.to change{Cookie.count}.by(1)

          expect(new_cookie.storage).to eq(oven)
        end

        it "redirects to the oven" do
          the_request
          expect(response).to redirect_to oven_path(oven)
        end

        it "assigns valid cookie parameters" do
          the_request
          expect(new_cookie.fillings).to eq(cookie_params[:fillings])
        end

        it 'creates a raw cookie' do
          the_request
          expect(new_cookie).not_to be_ready
        end

        it 'qeues a job to bake the cookie' do
          the_request

          expect(CookieBakerWorker).to have_enqueued_sidekiq_job(new_cookie.id).in(2.minutes)
        end
      end

      context "when an oven belonging to another user is supplied" do
        let(:oven) { FactoryGirl.create(:oven) }

        it "is not successful" do
          expect {
            the_request
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

  end
end
