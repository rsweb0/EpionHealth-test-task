require 'rails_helper'

RSpec.describe ScreenersController, type: :controller do
  let(:check_in) { create(:check_in) }

  describe "routing" do
    it { should route(:get, "/check_ins/1/screeners/new").to(action: :new, check_in_id: 1) }
    it { should route(:post, "/check_ins/1/screeners").to(action: :create, check_in_id: 1) }
    it { should route(:get, "/check_ins/1/screeners/1").to(action: :show, id: 1, check_in_id: 1) }
  end

  describe "GET #new" do
    it "renders the view" do
      get :new, params: { check_in_id: check_in.id }

      expect(response).to render_template(:new)
      expect(response).to render_with_layout(:application)
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
      post :create, params: params

      expect(Screener.count).to eq(1)
      expect(Response.count).to eq(2)
    end

    it "renders create view" do
      screener = create(:screener, check_in: check_in)
      allow(Screener).to receive(:new).and_return(screener)

      post :create, params: params

      expect(response).to redirect_to check_in_screener_path(id: screener.id, check_in_id: check_in.id)
    end
  end

  describe "GET #show" do
    it "finds the screener" do
      screener = create(:screener, check_in: check_in)

      get :show, params: { id: screener.id, check_in_id: check_in.id }

      expect(assigns[:screener]).to eq(screener)
    end

    it "shows the current screener" do
      screener = create(:screener, check_in: check_in)

      get :show, params: { id: screener.id, check_in_id: check_in.id }

      expect(response).to render_template(:show)
      expect(response).to render_with_layout(:application)
    end
  end
end
