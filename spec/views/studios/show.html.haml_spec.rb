require 'spec_helper'

describe "studios/show" do
  before(:each) do
    @studio = assign(:studio, stub_model(Studio,
      :name => "Name",
      :address => "Address",
      :lat => 1.5,
      :lng => 1.5,
      :photo_url => "Photo Url",
      :studio_url => "Studio Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Photo Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Studio Url/)
  end
end
