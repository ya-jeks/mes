require 'spec_helper'

describe SuppliersController, type: :controller do
  let(:supplier){ create :supplier}
  let(:user){ create :user}

  before{ sign_in(user)}

  describe "GET #index" do
    before{ get :index}
    it{ expect(assigns(:suppliers)).to eq [supplier]}
  end

  describe "GET #new" do
    before{ get :new}
    it{ expect(assigns(:suppliers)).to eq [supplier]}
  end

  describe "POST #create" do
    before{ post :create}
    it{ expect(assigns(:suppliers)).to eq [supplier]}
  end

  describe "PUT #update" do
    before{ put :update, id: supplier.id}
    it{ expect(assigns(:suppliers)).to eq [supplier]}
  end

  describe "DELETE #delete" do
    before{ delete :index, id: supplier.id}
    it{ expect(assigns(:suppliers)).to eq [supplier]}
  end

end
