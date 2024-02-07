// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint256 public targetAmount;
    uint256 public currentAmount;
    bool public fundraisingOpen;

    mapping(address => uint256) public balances;

    event Deposit(address indexed depositor, uint256 amount);
    event FundraisingClosed(uint256 totalAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier fundraisingOpenOnly() {
        require(fundraisingOpen, "Fundraising is closed");
        _;
    }

    constructor(uint256 _targetAmount) {
        owner = msg.sender;
        targetAmount = _targetAmount;
        fundraisingOpen = true;
    }

    function deposit() external payable fundraisingOpenOnly {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += msg.value;
        currentAmount += msg.value;

        emit Deposit(msg.sender, msg.value);

        if (currentAmount >= targetAmount*1000000000000000000) {
            closeFundraising();
        }
    }

    function closeFundraising() internal {
    if (currentAmount >= targetAmount*1000000000000000000) {
        fundraisingOpen = false;
        emit FundraisingClosed(currentAmount);
    }
}


    function withdraw() external onlyOwner {
        require(!fundraisingOpen, "Fundraising must be closed to withdraw funds");
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        this.deposit();
    }
}
