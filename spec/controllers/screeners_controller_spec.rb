require 'rails_helper'

RSpec.describe ScreenersController, type: :controller do
  let(:check_in) { create(:check_in) }

  describe "routing" do
    it { should route(:get, "/check_ins/1/screeners/new").to(action: :new, check_in_id: 1) }
    it { should route(:post, "/check_ins/1/screeners").to(action: :create, check_in_id: 1) }
  end

  describe "GET #new" do
    it "renders the view" do
      get :new, params: { check_in_id: check_in.id }, xhr: true

      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    before { Screener.destroy_all }

    let(:params) do
      {
        check_in_id: check_in.id,
        screener: {
          responses_attributes: {
            "0" => { question: "Test Question one", answer: 0 },
            "1" => { question: "Test Question two", answer: 2 }
          }
        }
      }
    end

    it "creates a new screener" do
      post :create, params: params, xhr: true

      expect(Screener.count).to eq(1)
      expect(Response.count).to eq(2)
    end

    it "renders create view" do
      post :create, params: params, xhr: true

      expect(response).to render_template(:create)
    end
  end
end
