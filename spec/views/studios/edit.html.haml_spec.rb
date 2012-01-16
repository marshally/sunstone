require 'spec_helper'

describe "studios/edit" do
  before(:each) do
    @studio = assign(:studio, stub_model(Studio,
      :name => "MyString",
      :address => "MyString",
      :lat => 1.5,
      :lng => 1.5,
      :photo_url => "MyString",
      :studio_url => "MyString"
    ))
  end

  it "renders the edit studio form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => studios_path(@studio), :method => "post" do
      assert_select "input#studio_name", :name => "studio[name]"
      assert_select "input#studio_address", :name => "studio[address]"
      assert_select "input#studio_lat", :name => "studio[lat]"
      assert_select "input#studio_lng", :name => "studio[lng]"
      assert_select "input#studio_photo_url", :name => "studio[photo_url]"
      assert_select "input#studio_studio_url", :name => "studio[studio_url]"
    end
  end
end
