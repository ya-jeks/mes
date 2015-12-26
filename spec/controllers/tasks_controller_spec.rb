require 'spec_helper'

describe TasksController, type: :controller do
  let(:task){ create :task}
  let(:user){ create :user}

  before{ sign_in(user)}

  describe "GET #index" do
    before{ get :index}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "GET #show" do
    before{ get :show}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "POST #create" do
    before{ post :create}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "POST #finish" do
    before{ post :finish, id: task.id}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "POST #deliver" do
    before{ post :deliver, id: task.id}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "POST #accept" do
    before{ post :accept, id: task.id}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

  describe "POST #reject" do
    before{ post :reject, id: task.id}
    it{ expect(assigns(:tasks)).to eq [task]}
  end

end
