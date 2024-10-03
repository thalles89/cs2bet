// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

struct Dispute {
    uint256 beginAt;
    uint256 endAt;
    string team1;
    string team2;
    string image1;
    string image2;
    uint256 totalAmmount1;
    uint256 totalAmmount2;
    uint256 totalVotes1;
    uint256 totalVotes2;
    uint256 winner;
    bool commissionPayed;
}

struct Bet {
    uint256 ammount;
    uint256 team;
    uint256 timestamp;
    uint256 claimmed;
    bool exists;
}

contract betteam {
    address owner;
    uint256 constant fee = 1000; // 10% 4 zeros scale
    Dispute public dispute;
    uint256 public netPrize;
    mapping(address => Bet) public bets;
    uint256 commission;

    string team1 = "Virtus Pro";
    string team2 = "Furia";
    string image1 = "https://eslpro.imgix.net/csgo/proleague/wp-content/uploads/2020/01/virtus.pro_.png";
    string image2 = "https://eslpro.imgix.net/csgo/proleague/wp-content/uploads/2023/03/furia-logo.png";

    uint256 immutable TIMESTAMPBEGIN = 1726959600000;
    uint256 immutable TIMESTAMPEND = 1730257200000;
    
    constructor() {
        owner = msg.sender;
        dispute = Dispute({
            beginAt: TIMESTAMPBEGIN,
            endAt: TIMESTAMPEND,
            team1: team1,
            team2: team2,
            image1: image1,
            image2: image2,
            totalAmmount1: 0,
            totalAmmount2: 0,
            totalVotes1: 0,
            totalVotes2: 0,
            winner: 0,
            commissionPayed: false
        });
    }

    function doBet(uint256 team) public payable {

        require(block.timestamp < dispute.beginAt, "too soon to bet");
        require(msg.value > 0, "Invalid Value");
        require(block.timestamp < dispute.endAt, "too late to bet");
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
            dispute.totalAmmount1 += msg.value;
            dispute.totalVotes1++;
        } else {
            dispute.totalAmmount2 += msg.value;
            dispute.totalVotes2++;        
        }

    }

    function endBets(uint256 winner) external {
        require(block.timestamp < dispute.endAt, "Too soon to end dispute");
        require(msg.sender == owner, "Sender is not the owner");
        require(winner == 1 || winner == 2, "Invalid winner");
        require(dispute.winner == 0, "Dispute closed");

        dispute.winner = winner;

        uint256 grossPrize = dispute.totalAmmount1 + dispute.totalAmmount2;
        commission = (grossPrize * fee) / 1e4;
        netPrize = grossPrize - commission;
    }

    function claim() external {
        Bet memory bet = bets[msg.sender];

        require(dispute.winner > 0 && dispute.winner == bet.team && bet.claimmed == 0, "Invalid Claim");

        uint256 winnerAmmount = dispute.winner == 1
            ? dispute.totalAmmount1
            : dispute.totalAmmount2;

        uint256 ratio = (bet.ammount * 1e4) / winnerAmmount;
        uint256 individualPrize = (netPrize * ratio) / 1e4;
        bets[msg.sender].claimmed = individualPrize;
        payable(msg.sender).transfer(individualPrize);
    }

    function withdrawComission() external {
        require(msg.sender == owner, "You're not the Contract owner");
        require(dispute.winner > 0, "Contract is not Closed yet");
        require(dispute.commissionPayed == false, "Owner already got his prize");
        dispute.commissionPayed = true;
        payable(owner).transfer(commission);
    }

    function chagePhoto1(string memory imageURI) external {
        require(msg.sender == owner, "You're not the Contract owner");
        dispute.image1 = imageURI;
    }

    function chagePhoto2(string memory imageURI) external {
        require(msg.sender == owner, "You're not the Contract owner");
        dispute.image2 = imageURI;
    }

    function updateTeam1(string memory team) external {
        require(msg.sender == owner, "You're not the Contract owner");
        dispute.team1 = team;
    }

    function updateTeam2(string memory team) external {
        require(msg.sender == owner, "You're not the Contract owner");
        dispute.team2 = team;
    }

    function updateBeginValidity(uint256 timestamp)  external {
        dispute.beginAt = timestamp ;
        require(msg.sender == owner, "You're not the Contract owner");
    }

    function updateEndValidity(uint256 timestamp)  external {
        require(msg.sender == owner, "You're not the Contract owner");
        dispute.endAt = timestamp ;
    }
}
