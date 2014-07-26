Feature: Playing the Game
	In order to win battleships
	As a nostalgic player
	I want to play the game

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
		Given I am on the deploy ship 2 page
			And my ships are deployed
		Then I should see "Waiting for the other player"

	Scenario: All ships deployed
		Given I am on the opponent deploy ship 1 page 
		When all ships are deployed
		Then I should see "Waiting for the other player"

	Scenario: Incorrect Coordinate
		Given I am waiting to shoot
		When I shoot at "a27"
		Then I should see "ENEMY"
			And I should see "FRIENDLY"

	Scenario: Hit
		Given I am waiting to shoot
		When I shoot at "a1"
		Then I should see "HIT"
			And I should see "Waiting for the other player"

	Scenario: Miss
		Given I am the next player to shoot
		When I shoot at "j9"
		Then I should see "MISS"
			And I should see "Waiting for the other player"

	Scenario: Misfire
		Given I am waiting to shoot
		When I shoot at "a1"
		Then I should see "MISFIRE"
			And I should see "ENEMY"
			And I should see "FRIENDLY"

	Scenario: Losing the game
		Given my opponent sinks all my ships
		Then I should see "DEFEATED!"

	Scenario: Losing the game
		Given I sink all my opponent's ships
		Then I should see "VICTORY!"


	