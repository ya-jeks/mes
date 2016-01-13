require 'spec_helper'

describe TasksController, type: :controller do
  let(:task){ create :task, user: user}
  let(:user){ create :user}
  before{ sign_in(user)}

  describe "GET #index" do
    before{ get :index, q: {supplier_id_eq: task.supplier_id}}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "GET #show" do
    before{ get :show, id: task.id}
    it{ expect(assigns(:task)).to eq task}
  end

end
