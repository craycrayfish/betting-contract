// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Bookie is Ownable {
    // Contract shall handle the betting for a single binary outcome
    address payable[] public players;
    uint256[] public bet_outcomes;
    uint256[] public bet_amounts;
    uint256[] public outcome_pool;
    uint256 public no_outcomes;

    enum STATE {
        BETTING_CLOSED,
        PRE_GAME,
        MID_GAME,
        POST_GAME
    }

    constructor() public {
        // Initialises variables
    }

    function get_game_state() public {
        // Call chainlink node to get live results
    }

    function calculate_odds() public {
        // Calculates the live payouts based on bets placed on each outcome
    }

    function place_bet(uint256 _outcome) public payable {
        // Saves the bets made by the player
        require(_outcome < no_outcomes, "Selected outcome not valid");
    }

    function calculate_payout(address _address) private returns (uint256) {
        // Calculates payout for a given address
        // Naive approach: split pot among winners proportional to amount bet
    }

    function claim_payout() public payable {
        // Allows winners to claim their payout
    }
}
