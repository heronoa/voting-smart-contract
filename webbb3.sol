// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

struct Voting {
    string option1;
    uint256 votes1;
    string option2;
    uint256 votes2;
    uint256 maxDate;
}

struct Vote {
    uint256 choice; //1 or 2
    uint256 date;
}

contract Webbb3 {
    address owner;
    uint256 public currentVoting = 0;
    Voting[] public votings;
    mapping(uint256 => mapping(address => Vote)) public votes;

    constructor() {
        owner = msg.sender;
    }

    function getCurrentVoting() public view returns (Voting memory) {
        return votings[currentVoting];
    }

    function addVoting(
        string memory option1,
        string memory option2,
        uint256 timeToVote
    ) public {
        require(msg.sender == owner, "Invalid Sender: Unauthorized");

        Voting memory newVoting;
        newVoting.option1 = option1;
        newVoting.option2 = option2;
        newVoting.maxDate = timeToVote + block.timestamp;
        votings.push(newVoting);
    }

    function addVote(uint256 choice) public {
        require(choice == 1 || choice == 2, "Invalid Choice");
        require(getCurrentVoting().maxDate > block.timestamp, "No open votes");
        require(
            votes[currentVoting][msg.sender].date == 0,
            "You already vote on this voting"
        );

        votes[currentVoting][msg.sender].choice = choice;
        votes[currentVoting][msg.sender].date = block.timestamp;
        if (choice == 1) votings[currentVoting].votes1++;
        else votings[currentVoting].votes2++;
    }
}
