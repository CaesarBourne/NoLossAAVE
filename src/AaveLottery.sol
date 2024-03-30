// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract AaveLottery {
    struct Round {
        uint256 endTime;
        uint256 totalStake;
        uint256 award;
        address winner;
    }
    struct Ticket {
        uint256 stake;
    }
    uint256 public roundDuration;
    constructor(uint256 _roundDuration) {
        roundDuration = _roundDuration;
    }

    function getRound(uint256 roundID) external view returns (Round memory) {}
    function getTicket(
        uint256 roundID,
        address user
    ) external view returns (Ticket memory) {}
    function enter(uint256 amount) external {
        //checks
        //updates
        //user enters
        //transfer funds from user to contract
        //deposit
    }
    function exit(uint256 amount) external {
        //checks
        //updates
        //user exits
        //transfer funds out to user from contract
        //deposit
    }
    function claim(uint256 amount) external {
        //checks
        //check user if real winner
        //Transfer jackpot
    }
}
