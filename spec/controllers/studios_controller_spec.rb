require 'spec_helper'

describe StudiosController do
  let(:studio) { Studio.create! slug: "the_studio" }

  describe "GET show" do
    it "assigns the requested studio as @studio" do
      get :show, { id: studio.to_param }
      assigns(:studio).should eq(studio)
    end
  end
end
