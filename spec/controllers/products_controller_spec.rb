require 'spec_helper'

describe ProductsController, type: :controller do
  let(:sku){ create :sku}
  let(:user){ create :user}
  let(:sales){ create :sales_supplier}
  let(:preset){ create :preset}
  let!(:ss){ create :sku_supplier, sku: sku, supplier: sales}

  before do
    user.suppliers << sales
    sku.product.presets << preset
    sign_in(user)
  end

  describe "GET #index" do
    before{ get :index}
    it{ expect(assigns(:products)).to eq [sku.product]}
  end

  describe "POST #preset" do
    before{ post :preset, id: ss.sku.product_id, preset: {id: preset.id}}
    it{ expect(assigns(:preset)).to eq preset}
  end

  describe "POST #configure" do
    before{ post :configure, id: sku.product_id}
    it{ expect(assigns(:products)).to eq [ss.sku.product]}
  end

  describe "GET #show" do
    before{ get :show, id: sku.product_id}
    it{ expect(assigns(:product)).to eq sku.product}
  end

end
