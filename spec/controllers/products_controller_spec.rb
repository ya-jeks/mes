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

end
