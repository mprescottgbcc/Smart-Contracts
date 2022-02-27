// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.0;
contract BallotV2 {

    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
       // address delegate;
    }

    struct Proposal {
        uint voteCount; // could add other data about proposal
    }

    enum Stage { Init, Reg, Vote, Done }

    Stage public stage = Stage.Init;
    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;
    uint startTime;
    

    /// Create a new ballot with $(_numProposals) different proposals.
    constructor(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
        stage = Stage.Reg;
        startTime = now; 
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    function register(address toVoter) public {
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
 
