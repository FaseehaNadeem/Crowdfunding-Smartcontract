// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding {
    mapping(address => uint) public contributors; //Ek mapping hai jo address ko contributions (ETH) ke amount se link karti hai.
    address public manager; // contract ka manager jo contract deploy karain ga 
    uint public minimumContribution; // kam sa kam kitni amount fund karni hogi
    uint public deadline; // fund ki last date
    uint public target; // kitna fund hona chahiyay
    uint public raisedAmount; // kitna fund ab tak howa hain 
    uint public noOfContributors; // fund  denay walu ki ginti

    constructor(uint _target, uint _deadline) {
        target = _target; // Funding goal
        deadline = block.timestamp + _deadline; // Deadline in seconds
        minimumContribution = 100 wei; // Minimum amount to contribute
        manager = msg.sender; // Contract deployer becomes manager
    }

    // Function to send ETH for crowdfunding
    //Yeh function contributors se paisa accept karta hai.
    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has passed"); // Check if deadline is not passed
        require(msg.value >= minimumContribution, "Minimum contribution not met"); // Check minimum contribution

        if (contributors[msg.sender] == 0) {
            // New contributor
            contributors[msg.sender] = msg.value;
        } else {
            // Existing contributor, add to their contribution
            contributors[msg.sender] += msg.value;
        }
        raisedAmount += msg.value; // Update the total raised amount
    }

    // Function to check contract balance
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Refund function if funding goal is not reached
    function refund() public {
        require(block.timestamp > deadline, "Deadline not yet reached"); // Ensure deadline has passed
        require(raisedAmount < target, "Funding target reached, no refunds"); // Refund only if target not met
        require(contributors[msg.sender] > 0, "You have no contributions"); // Ensure caller contributed

        address payable user = payable(msg.sender); // Convert to payable address
        uint contributedAmount = contributors[msg.sender];
        contributors[msg.sender] = 0; // Reset their contribution
        user.transfer(contributedAmount); // Refund ETH
    }

    // Only manager can withdraw funds if target is met
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // Function to withdraw funds if target is achieved
    function withdrawFunds() public onlyManager {
        require(raisedAmount >= target, "Funding target not met"); // Ensure target is reached
        address payable owner = payable(manager); // Convert manager to payable address
        owner.transfer(address(this).balance); // Transfer contract balance to manager
    }
}

// contributors[msg.sender]
// Yeh check karta hai ki jo person (sender) contract ko ETH bhej raha hai, kya woh pehli baar contribute kar 
//raha hai ya woh pehle bhi contribute kar chuka hai.
// msg.sender: Yeh sender ka address hai jo ETH bhej raha hai.
// msg.value: Yeh ETH ka amount hai jo sender bhej raha hai.
