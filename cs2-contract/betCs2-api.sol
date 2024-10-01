// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "@openzeppelin/contracts/utils/Strings.sol";

struct Dispute {
    uint256 beginAt;
    uint256 endAt;
    string team1;
    string team2;
    string image1;
    string image2;
    uint256 total1;
    uint256 total2;
    uint256 winner;
}

struct Bet {
    uint256 ammount;
    uint256 team;
    uint256 timestamp;
    uint256 claimmed;
    bool exists;
}

contract betteam {
    // on blockchain we only have integers, so it`s used the smallest currency ammount

    address owner;
    uint256 fee = 1000; // 10% 4 zeros scale
    Dispute public dispute;
    uint256 public netPrize;
    mapping(address => Bet) public bets;
    address[] public keys; 
    //  contract is open from 2024-09-21 20:00:00 until 2024-09-22 14:00:00 - game time (eg.)
    constructor() {
        owner = msg.sender;
        dispute = Dispute({
            beginAt: 1726959600000, // when can sender do a bet
            endAt: 1727024400000, // when is contract closed
            team1: "Eternal fire",
            team2: "mibr",
            image1: "https://en.wikipedia.org/wiki/Eternal_Fire_(esports)#/media/File:Eternal_fire_logo.png",
            image2: "https://pt.wikipedia.org/wiki/MIBR#/media/Ficheiro:Made_In_Brazil_logo.png",
            total1: 0,
            total2: 0,
            winner: 0
        });
    }

    function doBet(uint256 team) public payable {
        //require works diffrently than the if statement.
        //syntax is condition required, error message
        require(block.timestamp < dispute.beginAt, "too soon to bet");
        require(msg.value > 0, "Invalid Value");
        // require(block.timestamp > dispute.endAt, "to late to bet");
        require(dispute.winner == 0, "Dispute closed");
        require(team == 1 || team == 2, "Invalid team");
        require(msg.sender != owner, "Owner can't bet");
        require(bets[msg.sender].exists == false, "Sender alredy has a bet");
        
        Bet memory bet;
        bet.ammount = msg.value;
        bet.team = team;
        bet.timestamp = block.timestamp;
        bet.exists = true;
        bets[msg.sender] = bet;

        if (team == 1) {
            dispute.total1 += msg.value;
        } else {
            dispute.total2 += msg.value;
        }
    }

    function endBet(uint256 winner) external {
        require(block.timestamp > dispute.endAt, "Too soon to end dispute");
        require(msg.sender == owner, "Sender is not the owner");
        require(winner == 1 || winner == 2, "Invalid winner");
        require(dispute.winner == 0, "Dispute closed");

        dispute.winner = winner;

        uint256 grossPrize = dispute.total1 + dispute.total2;
        uint256 commission = (grossPrize * fee) / 1e4;
        netPrize = grossPrize - commission;

        payable(owner).transfer(commission);
    }

    function claim() external {
        Bet memory bet = bets[msg.sender];

        require(
            dispute.winner > 0 &&
                dispute.winner == bet.team &&
                bet.claimmed == 0,
            "Invalid Claim"
        );

        uint256 winnerAmmount = dispute.winner == 1
            ? dispute.total1
            : dispute.total2;
        uint256 ratio = (bet.ammount * 1e4) / winnerAmmount;
        uint256 individualPrize = (netPrize * ratio) / 1e4;
        bets[msg.sender].claimmed = individualPrize;
        payable(msg.sender).transfer(individualPrize);
    }

}
