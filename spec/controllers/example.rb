require 'spec_helper'

describe GroupsController do

  let(:valid_attributes) { {name: 'some name', rate: 0.5} }
  before{ sign_in(create :admin)}

  describe "GET index" do
    it "assigns all groups as @groups" do
      group = Group.create! valid_attributes
      get :index, {}
      assigns(:groups).should eq([group])
    end
  end

  describe "GET new" do
    it "assigns a new group as @group" do
      get :new, {}
      assigns(:group).should be_a_new(Group)
    end
  end

  describe "GET edit" do
    it "assigns the requested group as @group" do
      group = Group.create! valid_attributes
      get :edit, {:id => group.to_param}
      assigns(:group).should eq(group)
    end
  end

  describe "GET toggle_committer" do
    it "toggle a @group committer" do
      group = Group.create! valid_attributes
      request.env["HTTP_REFERER"] = 'http://localhost'

      get :toggle_committer, {:id => group.to_param}
      assigns(:group).rate.should eq(0)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Group" do
        expect {
          post :create, {:group => valid_attributes}
        }.to change(Group, :count).by(1)
      end

      it "assigns a newly created group as @group" do
        post :create, {:group => valid_attributes}
        assigns(:group).should be_a(Group)
        assigns(:group).should be_persisted
      end

      it "redirects to the groups" do
        post :create, {:group => valid_attributes}
        response.should redirect_to(groups_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved group as @group" do
        Group.any_instance.stub(:save).and_return(false)
        post :create, {:group => {  }}
        assigns(:group).should be_a_new(Group)
      end

      it "re-renders the 'new' template" do
        Group.any_instance.stub(:save).and_return(false)
        post :create, {:group => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested group" do
        group = Group.create! valid_attributes
        Group.any_instance.should_receive(:update).with({ "name" => "name1", "rate" => "0.3" })
        put :update, {:id => group.to_param, :group => { "name" => "name1", "rate" => "0.3" }}
      end

      it "assigns the requested group as @group" do
        group = Group.create! valid_attributes
        put :update, {:id => group.to_param, :group => valid_attributes}
        assigns(:group).should eq(group)
      end

      it "redirects to the group" do
        group = Group.create! valid_attributes
        put :update, {:id => group.to_param, :group => valid_attributes}
        response.should redirect_to(groups_url)
      end
    end

    describe "with invalid params" do
      it "assigns the group as @group" do
        group = Group.create! valid_attributes
        Group.any_instance.stub(:save).and_return(false)
        put :update, {:id => group.to_param, :group => {  }}
        assigns(:group).should eq(group)
      end

      it "re-renders the 'edit' template" do
        group = Group.create! valid_attributes
        Group.any_instance.stub(:save).and_return(false)
        put :update, {:id => group.to_param, :group => {  }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested group" do
      group = Group.create! valid_attributes
      expect {
        delete :destroy, {:id => group.to_param}
      }.to change(Group, :count).by(-1)
    end

    it "redirects to the groups list" do
      group = Group.create! valid_attributes
      delete :destroy, {:id => group.to_param}
      response.should redirect_to(groups_url)
    end
  end

end
