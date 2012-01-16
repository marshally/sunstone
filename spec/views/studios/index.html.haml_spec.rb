require 'spec_helper'

describe "studios/index" do
  before(:each) do
    assign(:studios, [
      stub_model(Studio,
        :name => "Name",
        :address => "Address",
        :lat => 1.5,
        :lng => 2.5,
        :photo_url => "Photo Url",
        :studio_url => "Studio Url"
      ),
      stub_model(Studio,
        :name => "Name",
        :address => "Address",
        :lat => 1.5,
        :lng => 2.5,
        :photo_url => "Photo Url",
        :studio_url => "Studio Url"
      )
    ])
  end

  it "renders a list of studios" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Photo Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Studio Url".to_s, :count => 2
  end
end
