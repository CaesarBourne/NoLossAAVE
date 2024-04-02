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
    uint256 public currentID; //current Round

    //roundId => Round
    mapping(uint256 => Round) public rounds;

    // roundID =>  userAddress => Ticket
    mapping(uint256 => mapping(address => Ticket)) public tickets;
    constructor(uint256 _roundDuration) {
        roundDuration = _roundDuration;
    }

    function getRound(uint256 roundID) external view returns (Round memory) {
        return rounds[roundID];
    }

    function getTicket(
        uint256 roundID,
        address user
    ) external view returns (Ticket memory) {
        return tickets[roundID][user];
    }
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

    funtion _drawWinner() internal view returns (uint256){
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    rounds[currentID].totalStake
                    //totalstake
                    //round
                );
            )
        )
    }
}
