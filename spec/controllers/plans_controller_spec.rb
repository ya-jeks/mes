require 'spec_helper'

describe PlansController, type: :controller do
  let(:user){ create :user}
  let(:sales){ create :sales_supplier}

  before{ sign_in(user)}

  describe "GET #index" do
    before{ get :index}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "GET #new" do
    before{ get :new}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "POST #create" do
    before{ post :create, plan: attributes_for(:plan)}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

end
