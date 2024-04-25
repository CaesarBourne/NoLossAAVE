// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract AaveLottery {
    struct Round {
        uint256 endTime;
        uint256 totalStake;
        uint256 award;
        uint256 winnerTicket;
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
        //in the first round
        rounds[currentId] = Round(
            block.timestamp + _roundDuration,
            0,
            0,
            0,
            address(0)
        );
    }

    function getRound(uint256 roundID) external view returns (Round memory) {
        return rounds[roundID];
    }

    function getTicket(
        uint256 roundId,
        address user
    ) external view returns (Ticket memory) {
        return tickets[roundId][user];
    }

    function enter(uint256 amount) external {
        // Checks
        require(
            tickets[currentId][msg.sender].stake == 0,
            "USER_ALREADY_PARTICIPANT"
        );
        // Update
        _updateState();
        // User enters
        // [totalStake, totalStake + amount)
        tickets[currentId][msg.sender].segmentStart = rounds[currentId]
            .totalStake;
        tickets[currentId][msg.sender].stake = amount;
        rounds[currentId].totalStake += amount;
        // Transfer funds in - user must approve this contract
        underlying.safeTransferFrom(msg.sender, address(this), amount);
        // Deposit funds into Aave Pool
        uint256 scaledBalanceStakeBefore = aToken.scaledBalanceOf(
            address(this)
        );
        aave.deposit(address(underlying), amount, address(this), 0);
        uint256 scaledBalanceStakeAfter = aToken.scaledBalanceOf(address(this));
        rounds[currentId].scaledBalanceStake +=
            scaledBalanceStakeAfter -
            scaledBalanceStakeBefore;
    }

    function exit(uint256 roundID) external {
        //checks
        //updates
        _updateState();
        require(roundID < currentID, "CURRENT_LOTTERY");

        //user exits
        uint256 amount = tickets[roundID][msg.sender].stake;
        rounds[roundID].totalStake -= amount;
        //transfer funds out to user from contract
        //deposit
    }
    function claim(uint256 amount) external {
        //checks
        //check user if real winner
        //Transfer jackpot
    }

    function _drawWinner(uint256 total) internal view returns (uint256) {
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    rounds[currentID].totalStake
                    //totalstake
                    //round
                )
            )
        );
        return random % total; // [0, tot ]
    }
    function _updateState() internal {
        if (block.timestamp > rounds[currentID].endTime) {
            // award - aave withdraw
            // scaledBalance * index = total amount of aTokens
            uint256 index = aave.getReserveNormalizedIncome(
                address(underlying)
            );
            uint256 aTokenBalance = rounds[currentID].scaledBalanceStake.rayMul(
                index
            );
            uint256 aaveAmount = aave.withdraw(
                address(underlying),
                aTokenBalance,
                address(this)
            );
            // aaveAmount = principal + interest
            rounds[currentID].award = aaveAmount - rounds[currentID].totalStake;

            // Lottery draw
            rounds[currentID].winnerTicket = _drawWinner(
                rounds[currentID].totalStake
            );

            // create a new round
            currentID += 1;
            rounds[currentID].endTime = block.timestamp + roundDuration;
        }
    }
}
