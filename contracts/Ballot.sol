pragma solidity ^0.5.16;

contract Ballot {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted; // if true, that person already voted
        uint8 vote; // index of the voted proposal
        address delegate;  // address delegate;
    }

    //modifer
    modifier onlyOwner () {
      require(msg.sender == chairperson);
      _;
    }

    /* struct Proposal {
        uint voteCount; // could add other data about proposal
    } */
    struct Proposal {
        bytes32 name; // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    
    // This declares a state variable that
    // stores a `Voter` struct for each possible address.

   mapping(address => Voter) public voters;

    // Create a new ballot with 4 different proposals:
    uint[4] public proposals;

    
    constructor() public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;

    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    function register(address toVoter) public onlyOwner{
     
     if(voters[toVoter].weight != 0) revert();
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
    }

    

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= 4 || sender.weight == 0) revert();
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal] += sender.weight;
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner:

    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < 4; prop++)
            if (proposals[prop] > winningVoteCount) {
                winningVoteCount = proposals[prop];
                _winningProposal = prop;
            }
    }

    function getCount() public view returns (uint[4] memory) {
        return proposals;
    }

}