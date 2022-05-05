// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Bookie is Ownable {
    // Contract shall handle the betting for a single binary outcome
    uint256 public no_bets;
    mapping(address => uint256[]) public bets; // bettor positions in bet arrays
    uint256[] public bet_outcomes;
    uint256[] public bet_amounts;
    uint256 public no_outcomes;
    mapping(uint256 => uint256) public payouts;

    enum STATE {
        CLOSED,
        PRE_GAME,
        MID_GAME,
        POST_GAME
    }
    STATE public state;

    constructor() public {
        // Initialises variables
        state = STATE.CLOSED;
        no_bets = 0;
    }

    function start_betting() public onlyOwner {
        require(state == STATE.CLOSED, "Betting already started!");
        state = STATE.PRE_GAME;
    }

    function get_game_state() public {
        // Call chainlink node to get live results
    }

    function update_odds() public {
        // Calculates the live payouts based on bets placed on each outcome
    }

    function place_bet(uint256 _outcome) public payable {
        // Saves the bets made by the player
        require(state != STATE.CLOSED, "Betting not allowed now");
        require(_outcome < no_outcomes, "Selected outcome not valid");
        require(msg.value > 0, "Bet value must be greater than 0");

        bets[msg.sender].push(no_bets);
        bet_outcomes.push(_outcome);
        bet_amounts.push(msg.value);
        update_odds();
    }

    function calculate_payout(address _address) private returns (uint256) {
        // Calculates payout for a given address
        // Naive approach: split pot among winners proportional to amount bet
    }

    function claim_payout() public payable {
        // Allows winners to claim their payout
    }
}
