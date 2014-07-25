Feature: Playing the Game
	In order to win battleships
	As a nostalgic player
	I need to play the game

Scenario: Incorrect Coordinate
	Given the game has started
		And I am waiting to shoot
	When I shoot at "a27"
	Then I should see "BAD Coordinate"

Scenario: Hit
	Given I am waiting to shoot
	When I shoot at "a1"
	Then I should see "HIT"
		And "Waiting for other player"

Scenario: Miss
	Given I am waiting to shoot
	When I shoot at "j9"
	Then I should see "MISS"
		And "Waiting for other player"

Scenario: Misfire
	Given I am waiting to shoot
	When I shoot at "a1"
	Then I should see "MISFIRE"
		And "Let's rock and roll"

Scenario: Losing the game
	Given my opponent sinks all my ships
	Then I should see "DEFEATED!"

Scenario: Losing the game
	Given I sink all my opponent's ships
	Then I should see "VICTORY!"
