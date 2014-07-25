Feature: Starting the game
	In order to play battleships
	As a nostalgic player
	I want to start a new game

	Scenario: Registering Player
		Given I am on the homepage
		When I follow "launch-name-input"
		Then I should see "Please enter your name to start a game:"
		When I fill "player" with "Jeremy"
			And I press "Go!"
		Then I should see "Waiting for the other player"

	Scenario: Registering Error Player 
		Given I am on the homepage
		When I follow "launch-name-input"
		Then I should see "Please enter your name to start a game:"
		When I fill "player" with ""
			And I press "Go!"
		Then I should not see "Waiting for the other player"
		
	Scenario: Registering 2nd Player
		Given "Jeremy" has registered
			And I am on the homepage
		When I follow "launch-name-input"
		Then I should see "Please enter your name to start a game:"
		When I fill "player" with "NotJeremy"
			And I press "Go!"
		Then I should see "Deploy your ships to battle"
			And I should see "AircraftCarrier"	

	Scenario: Trying to Register a 3rd Player
		Given I am on the homepage
		When I follow "launch-name-input"
		Then I should see "Please enter your name to start a game:"
		When I fill "player" with "ThirdWheel"
			And I press "Go!"
		Then I should see "The BattleShip server is currently full!"

	Scenario: Validation
		Given I am on the deploy ship 1 page
		When I fill "ship_start" with "a1"
			And I fill "ship_end" with "a9"
			And I press "Deploy!"
		Then I should see "ERROR: Bad Coordinate"
			And I should see "AircraftCarrier"

	Scenario: Deploying a ship
		Given I am on the deploy ship 1 page
		When I fill "ship_start" with "a1"
			And I fill "ship_end" with "a5"
			And I press "Deploy!"
		Then I should see "Battleship"

	Scenario: Validation II
		Given I am on the deploy ship 2 page
		When I fill "ship_start" with "a1"
			And I fill "ship_end" with "a5"
			And I press "Deploy!"
		Then I should see "ERROR: Bad Coordinate"
			And I should see "Battleship"

	Scenario: All own ships deployed
		Given Jeremy's" ships are deployed
		Then I should see "Waiting for the other player"

	Scenario: All ships deployed
		Given all ships are deployed
		Then I should see "Let's rock and roll"
			And I should see a "Fire!" button


	