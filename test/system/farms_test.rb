require "application_system_test_case"

class FarmsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit farms_url
  #
  #   assert_selector "h1", text: "Farm"
  # end
  test "visiting the index" do
    login_as users(:henrique)
    visit '/farms/new'
    assert_selector "h1", text: "Painel de Controle"
    save_and_open_screenshot
  end
end
