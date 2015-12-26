require 'spec_helper'

describe ProductsController, type: :controller do
  let(:user){ create :user}
  let(:sales){ create :sales_supplier}
  let!(:ss){ create :sku_supplier, supplier: sales}

  before do
    user.suppliers << sales
    sign_in(user)
  end

  describe "GET #index" do
    before{ get :index}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "POST #preset" do
    before{ post :preset, id: ss.sku.product_id}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "POST #configure" do
    before{ post :configure, id: ss.sku.product_id}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "GET #show" do
    before{ get :show, id: ss.sku.product_id}
    it{ expect(assigns(:product)).to eq ss.sku.product}
  end

end
