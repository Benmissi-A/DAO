//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract DAO {
    using Counters for Counters.Counter;
    enum Vote {
        Yes,
        No
    }
    enum Status {
        Running,
        Aproved,
        Rejected
    }
    struct Proposal {
        string proposition;
        address author;
        uint256 createdAt;
        uint256 nbYes;
        uint256 nbNo;
        Status status;
    }
    uint256 private _id;
    mapping(uint256 => Proposal) private _proposals;

    function createProposal(string memory proposition) public returns (uint256) {
        _id.increment();
        uint256 id = _proposals[_id.current()];
        _proposals[id]= Proposal({
            status:Status.Running,
            author: msg.sender,
            createdAt : block.timestamp,
            nbYes : 0,
            nbNo: 0,
            proposition: proposition
        });
        return id;
    }

    function vote() public {}

    function proposalById(uint256 id) public view returns (Proposal memory) {
        return _proposals[id];
    }
}
