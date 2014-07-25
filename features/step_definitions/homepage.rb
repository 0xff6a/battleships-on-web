Given(/^I am on the homepage$/) do
	visit '/'
end

Given(/^I am on the deploy ship (\d+) page$/) do |index|
  visit "/launch_game/Jeremy/#{(index.to_i) - 1}"
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

def register_player(name)
  visit '/'
  click_link "launch-name-input"
  fill_in("player", :with => name)
  click_on("Go!")
end

