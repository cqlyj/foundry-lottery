// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title A Raffle contract
 * @author Luo Yingjie
 * @notice This contract is used to implement a raffle
 * @dev Implement Chainlink VRF to generate random numbers
 */

contract Raffle {
    error Raffle__NotEnoughEthSent();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /** Events */
    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        // cost more gas
        // require(
        //     msg.value >= i_entranceFee,
        //     "Not enough ETH to enter the raffle"
        // );

        // more gas efficient
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() public {}

    //** Getter Functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
