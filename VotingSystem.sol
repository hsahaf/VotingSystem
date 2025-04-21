// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
contract VotingSystem {

    struct Voter {
        bool hasVoted;
        bool isCandidate;
    }

    address private owner;
    address[] public allCandidates; // array to store only the registered candidates
    mapping(address => Voter) public voters; // mapping to store all voters and respective info
    mapping(address => uint) public voteCount;     // To track the number of votes for each candidate
    
    
    constructor() {
    owner = msg.sender;
    }
    
    modifier onlyOwner() { // Modifier
        require(
            msg.sender == owner,
            "Only owner can call this."
        );
        _;
    }
    
    
    function addCandidate(address _candidate) external onlyOwner returns (bool) {
    require(!voters[_candidate].isCandidate, "User is a candidate."); //Check if the user is already a candidate first.
    require(_candidate != owner, "Owner cannot be a candidate."); //Owner should not be allowed to add themselves.
    voters[_candidate].isCandidate = true;
    allCandidates.push(_candidate);
    return true;
}

    function removeCandidate(address _candidate) external onlyOwner returns (bool) {
        require(voters[_candidate].isCandidate, "Not a candidate.");
        voters[_candidate].isCandidate = false;

        uint len = allCandidates.length;
        for (uint i = 0; i < len; i++) {
            if (allCandidates[i] == _candidate) {
                allCandidates[i] = allCandidates[len - 1];
                allCandidates.pop();
                break;
            }
        }
        return true;
    }

    function updateOwner(address _newOwner) external onlyOwner returns (bool) {
        require(_newOwner != address(0), "Invalid address.");
        owner = _newOwner;
        return true;
    }

    function vote(address _candidate) external returns (bool){
    address voter = msg.sender;
    require(!voters[voter].hasVoted, "Already voted.");
    require(voters[_candidate].isCandidate, "Not a candidate.");
  
    require(msg.sender != owner, "Owner can't vote.");
    voters[voter].hasVoted = true; // Mark voter as voted
    // Track vote for candidate
    voteCount[_candidate]++; // Increment the candidate's vote count
    return true;
}
    
    function viewVotes(address _candidate) external view onlyOwner returns (uint) {
        require(voters[_candidate].isCandidate, "Not a candidate.");
        return voteCount[_candidate]; // Return the number of votes for a given candidate
    }

    function getWinner() external view returns (address winner) {
        uint maxVotes = 0;
        for (uint i = 0; i < allCandidates.length; i++) {
            address candidate = allCandidates[i];
            if (voteCount[candidate] > maxVotes) {
                maxVotes = voteCount[candidate];
                winner = candidate;
            }
        }
    }

}
