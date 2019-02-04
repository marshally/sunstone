require 'spec_helper'

describe "studios/index" do
  before(:each) do
    assign(:studios, [
      stub_model(Studio,
        name: "Name",
        address: "Address",
        lat: 1.5,
        lng: 2.5,
        photo_url: "Photo Url",
        studio_url: "Studio Url1",
        slug: "studio_url"

      ),
      stub_model(Studio,
        name: "Name",
        address: "Address",
        lat: 1.5,
        lng: 2.5,
        photo_url: "Photo Url",
        studio_url: "Studio Url2",
        slug: "studio_url2"
      )
    ])
  end

  # it "renders a list of studios" do
  #   render
  #
  #   assert_select "tr>td", text: "Name".to_s, count: 2
  #   assert_select "tr>td", text: "Address".to_s, count: 2
  #   assert_select "tr>td", text: "Add to iCal".to_s, count: 2
  # end
end
