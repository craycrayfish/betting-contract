// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ChainlinkConsumer.sol";

contract Bookie is Ownable, ChainlinkConsumer {
    // Contract shall handle the betting for a single binary outcome
    uint256 public betCount;
    mapping(address => uint256[]) public bets; // bettor positions in bet arrays
    uint256[] public betOutcomes;
    uint256[] public betAmounts;
    uint256 public totalBetAmount;
    uint256 public totalWinningBetAmount;
    mapping(uint256 => uint256) public outcomeAmounts;
    mapping(uint256 => uint256) public payouts;

    // Game state
    uint256 public outcomeCount;
    mapping(uint256 => GameResolve) public outcomeStates; // 1 indexed
    uint256 public winningOutcome;

    enum STATE {
        CLOSED,
        PRE_GAME,
        MID_GAME,
        POST_GAME
    }
    STATE public state;

    constructor() {
        // Initialises variables
        state = STATE.CLOSED;
        betCount = 0;
        winningOutcome = 0;
        totalBetAmount = 0;
        totalWinningBetAmount = 0;
    }

    /* ===== CHAINLINK FUNCTIONS ======= */

    function setChainlink(address _oracle, address _token) public onlyOwner {
        setChainlinkOracle(_oracle);
        setChainlinkToken(_token);
    }

    function requestResults(
        bytes32 _specId,
        uint256 _payment,
        string memory _market,
        uint256 _sportId,
        uint256 _date
    ) external onlyOwner {
        requestGames(_specId, _payment, _market, _sportId, _date);
    }

    /* ==== INTERNAL STATE FUNCTIONS ======= */

    function start_betting() public onlyOwner {
        require(state == STATE.CLOSED, "Betting already started!");
        state = STATE.PRE_GAME;
    }

    function addOutcome(GameResolve memory _gameState) public onlyOwner {
        outcomeCount += 1;
        outcomeStates[outcomeCount] = _gameState;
    }

    function endBetting() external onlyOwner {
        // End betting and tally totals for winning outcome
        GameResolve memory winState = getLatestResults();
        for (uint256 i = 0; i < outcomeCount; i++) {
            if (_generateHash(outcomeStates[i]) == _generateHash(winState)) {
                winningOutcome = i;
                break;
            }
        }
    }

    function _generateHash(GameResolve memory results)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    results.gameId,
                    results.homeScore,
                    results.awayScore,
                    results.statusId
                )
            );
    }

    /* ===== BET MANAGEMENT FUNCTIONS ======= */

    function claimPayout() public {
        // Allows winners to claim their payout
        require(bets[msg.sender].length > 0, "Payout not available.");
        require(
            state == STATE.POST_GAME,
            "Game still going on, please wait till game ends"
        );
        uint256 payout = calculatePayout(msg.sender);
        if (payout > 0) {
            sendPayout(msg.sender, payout);
            _clearBets(msg.sender); // clear bets to prevent double claiming
        }
    }

    function calculatePayout(address _address) public view returns (uint256) {
        // Calculates payout for a given address
        // Naive approach: split pot among winners proportional to amount bet
        (uint256[] memory _outcomes, uint256[] memory _amounts) = _getBets(
            _address
        );
        uint256 _payout = 0;
        for (uint256 i = 0; i < _outcomes.length; i++) {
            if (_outcomes[i] == winningOutcome) {
                _payout +=
                    (totalBetAmount * _amounts[i]) /
                    totalWinningBetAmount;
            }
        }
        return _payout;
    }

    function _getBets(address _address)
        public
        view
        returns (uint256[] memory, uint256[] memory)
    {
        // Returns bets placed by an address
        uint256[] memory indices = bets[_address];
        uint256[] memory bettorOutcomes = new uint256[](indices.length);
        uint256[] memory bettorAmounts = new uint256[](indices.length);
        for (uint256 i = 0; i < indices.length; i++) {
            uint256 idx = indices[i];
            bettorOutcomes[i] = betOutcomes[idx];
            bettorAmounts[i] = betAmounts[idx];
        }
        return (bettorOutcomes, bettorAmounts);
    }

    function sendPayout(address _address, uint256 _amount) private {
        // Sends eth to an address
        address payable winningAddress = payable(_address);
        winningAddress.transfer(_amount);
    }

    function _clearBets(address _address) internal {
        // Remove the betting array for the bettor once payout claimed
        delete bets[_address];
    }

    /* ==== UI FUNCTIONS ========== */

    function placeBet(uint256 _outcome) public payable {
        // Saves the bets made by the player
        require(state != STATE.CLOSED, "Betting not allowed now");
        require(_outcome <= outcomeCount, "Selected outcome not valid");
        require(msg.value > 0, "Bet value must be greater than 0");

        bets[msg.sender].push(betCount);
        betOutcomes.push(_outcome);
        betAmounts.push(msg.value);
        updateOdds();
    }

    function updateOdds() public view {
        // Calculates the live payouts based on bets placed on each outcome
    }

    function showOutcomes(uint256 _outcome)
        external
        view
        returns (GameResolve memory)
    {
        // Returns the outcome GameResolve
        require(_outcome > 0, "Outcome must be above 0");
        return (outcomeStates[_outcome]);
    }
}
