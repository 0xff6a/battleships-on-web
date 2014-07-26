Given(/^I am on the homepage$/) do
	visit '/'
end

Given(/^I am on the deploy ship (\d+) page$/) do |index|
  visit "/launch_game/Jeremy/#{(index.to_i) - 1}"
end

Given(/^I am on the opponent deploy ship (\d+) page$/) do |index|
  visit "/launch_game/NotJeremy/#{(index.to_i) - 1}"
end

Given(/^I am on the wait page$/) do
  visit '/waiting_to_shoot/Jeremy'
end

Given(/^I am waiting to shoot$/) do
 visit '/play_game/Jeremy'
end

Given(/^I am the next player to shoot$/) do
  visit '/play_game/NotJeremy'
end

Given(/^I am on the reset page$/) do
  visit '/reset'
end

When(/^I follow "(.*?)"$/) do |link_name|
  click_link(link_name)
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  expect(page).not_to have_content(text)
end

When (/^I fill "(.*?)" with "(.*?)"$/)  do |field, value|
    fill_in(field, :with => value)
end

When(/^I shoot at "(.*?)"$/) do |coordinate|
   fire_at(coordinate)
end

When(/^I press "(.*?)"$/) do |button|
  click_on(button)
end

Then(/^I should stay on "(.*?)"$/) do |path|
  # expect(current_path).to eq(path)
end

Then(/^I the "(.*?)" button should have validation$/) do |button|
  page.all(button, :required => true)
end

Given(/^"(.*?)" has registered$/) do |player|
  visit '/'
end

Given(/^2 players have registered$/) do 
 register_player("Jeremy")
 register_player("NotJeremy")
end

Given(/^my ships are deployed$/) do 
  place_ship("b1", "b4")
  place_ship("c1", "c3")
  place_ship("d1", "d3")
  place_ship("e1", "e2")
end

When(/^all ships are deployed$/) do
  place_all_ships("NotJeremy")
end

Given(/^I sink all my opponent's ships$/) do
  coordinates = %w(a1, a2, a3, a4, a5, b1, b2, b3, b4, c1, c2, c3, d1, d2, d3, e1, e2)
  coordinates.each do |coordinate| 
    visit '/play_game/Jeremy'
    fire_at(coordinate) 
  end 
end

When(/^I try to register a player$/) do
  register_player("Hubot")
end

def fire_at(coordinate)
  fill_in('coordinate', :with => coordinate)
  click_on("Fire!")
end

def register_player(name)
  visit '/'
  click_link "launch-name-input"
  fill_in("player", :with => name)
  click_on("Go!")
end

def place_all_ships(name)
  visit "/launch_game/#{name}/0"
  place_ship("a1", "a5")
  place_ship("b1", "b4")
  place_ship("c1", "c3")
  place_ship("d1", "d3")
  place_ship("e1", "e2")
end

def place_ship(first, last)
  fill_in("ship_start", :with => first)
  fill_in("ship_end", :with => last)
  click_on("Deploy!")
end
