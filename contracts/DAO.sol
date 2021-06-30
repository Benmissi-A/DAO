//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract DAO {
    using Counters for Counters.Counter;
    
    enum Vote {Yes, No}
    enum Status {Running, Approved, Rejected}
    
    struct Proposal {
        Status status;
        address author;
        uint256 createdAt;
        uint256 nbYes;
        uint256 nbNo;
        string proposition;
    }
    
    uint256 constant public TIME_LIMIT = 3 minutes;
    
    Counters.Counter private _id;
    mapping(uint256 => Proposal) private _proposals;
    mapping(address => mapping(uint256 => bool)) private _hasVote;
    
    
    function createProposal(string memory proposition) public returns(uint256) {
        _id.increment();
        uint256 id = _id.current();
        _proposals[id] = Proposal({
            status: Status.Running,
            author: msg.sender,
            createdAt: block.timestamp,
            nbYes: 0, 
            nbNo: 0,
            proposition: proposition
        });
        return id;
        
    }
    
    function vote(uint256 id, Vote vote_) public {
        require(_hasVote[msg.sender][id] == false, "DAO: Already voted");
        require(_proposals[id].status == Status.Running, "DAO: Not a running proposal");
        
        if(block.timestamp > _proposals[id].createdAt + TIME_LIMIT) {
            if(_proposals[id].nbYes > _proposals[id].nbNo) {
                _proposals[id].status = Status.Approved;
            } else {
                _proposals[id].status = Status.Rejected;
            }
        } else {
            if(vote_ == Vote.Yes) {
                _proposals[id].nbYes += 1;
            } else {
                _proposals[id].nbNo += 1;
            }
            _hasVote[msg.sender][id] = true;
        }
    }
    
    function proposalById(uint256 id) public view returns(Proposal memory) {
        return _proposals[id];
    }
    
    function hasVote(address account, uint256 id) public view returns(bool) {
        return _hasVote[account][id];
    }
}
