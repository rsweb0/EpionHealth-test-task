require 'rails_helper'

RSpec.describe ScreenersController, type: :controller do
  let(:check_in) { create(:check_in) }

  describe "routing" do
    it { should route(:get, "/check_ins/1/screeners/new").to(action: :new, check_in_id: 1) }
    it { should route(:post, "/check_ins/1/screeners").to(action: :create, check_in_id: 1) }
    it { should route(:get, "/check_ins/1/screeners/1").to(action: :show, id: 1, check_in_id: 1) }
    it { should route(:get, "/check_ins/1/screeners/1/edit").to(action: :edit, check_in_id: 1, id: 1) }
    it { should route(:patch, "/check_ins/1/screeners/1").to(action: :update, check_in_id: 1, id: 1) }
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

    it "redirects to show view" do
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

    it "sets message and initializes next screener" do
      screener = create(:screener, check_in: check_in)
      create(:response, screener: screener, id: 1, answer: 3)
      create(:response, screener: screener, id: 2, answer: 3)

      get :show, params: { id: screener.id, check_in_id: check_in.id }

      expect(assigns[:message]).to eq("Additional screening should be completed.")
      expect(assigns[:next_screener]).to be_new_record
    end
  end

  describe "GET #edit" do
    it "renders the view" do
      screener = create(:screener, check_in: check_in)

      get :edit, params: { check_in_id: check_in.id, id: screener.id }

      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let!(:screener) { create(:screener, check_in: check_in) }
    let!(:response1) { create(:response, screener: screener, id: 1, answer: 0) }
    let!(:response2) { create(:response, screener: screener, id: 2, answer: 0) }

    let(:params) do
      {
        id: screener.id,
        check_in_id: check_in.id,
        screener: {
          responses_attributes: {
            "0" => { id: 1, question: "Updated Question one", answer: 2 },
            "1" => { id: 2, question: "Updated Question two", answer: 3 }
          }
        }
      }
    end

    it "updates the screener responses" do
      patch :update, params: params

      response1.reload
      response2.reload

      expect(response1.question).to eq("Updated Question one")
      expect(response1.answer).to eq(2)
      expect(response2.question).to eq("Updated Question two")
      expect(response2.answer).to eq(3)
    end

    it "redirects to show view" do
      patch :update, params: params

      expect(response).to redirect_to check_in_screener_path(id: screener.id, check_in_id: check_in.id)
    end
  end
end
