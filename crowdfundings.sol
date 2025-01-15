// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding {
    mapping(address => uint) public contributors;  
    address public manager;
    uint public minimumContribution; 
    uint public deadline;
    uint public target; 
    uint public raisedAmount; 
    uint public noOfContributors; 

    constructor(uint _target, uint _deadline) {
        target = _target; // Funding goal
        deadline = block.timestamp + _deadline; 
        minimumContribution = 100 wei; 
        manager = msg.sender; 
    }

    
    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has passed"); 
        require(msg.value >= minimumContribution, "Minimum contribution not met"); 

        if (contributors[msg.sender] == 0) {
            // New contributor
            contributors[msg.sender] = msg.value;
        } else {
            // Existing contributor, add to their contribution
            contributors[msg.sender] += msg.value;
        }
        raisedAmount += msg.value; 
    }

    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    
    function refund() public {
        require(block.timestamp > deadline, "Deadline not yet reached"); 
        require(raisedAmount < target, "Funding target reached, no refunds"); 
        require(contributors[msg.sender] > 0, "You have no contributions"); 

        address payable user = payable(msg.sender); 
        uint contributedAmount = contributors[msg.sender];
        contributors[msg.sender] = 0; 
        user.transfer(contributedAmount); 
    }

   
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    
    function withdrawFunds() public onlyManager {
        require(raisedAmount >= target, "Funding target not met"); 
        address payable owner = payable(manager); 
        owner.transfer(address(this).balance); 
    }
}
