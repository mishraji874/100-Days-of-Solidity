//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AutomaticBillPayments {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => mapping(uint256 => Bill)) public bills;

    struct Bill {
        address recipient;
        uint256 amount;
        uint256 dueDate;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }


    function createBill(address _recipient, uint256 _amount, uint256 _dueDate) external onlyOwner {
        uint256 billIndex = bills[_recipient][block.timestamp].amount > 0 ? block.timestamp + 1 : block.timestamp;
        bills[_recipient][billIndex] = Bill(_recipient, _amount, _dueDate);
    }

    function payBill(uint256 _billIndex) external {
        Bill storage bill = bills[msg.sender][_billIndex];
        require(bill.recipient == msg.sender, "You are not the bill recipient");
        require(bill.amount <= balances[msg.sender], "Insufficient balance");
        require(block.timestamp >= bill.dueDate, "Bill is not yet due");
        balances[msg.sender] -= bill.amount;
        (bool success, ) = bill.recipient.call{value: bill.amount}("");
        require(success, "Payment failed");
        delete bills[msg.sender][_billIndex];
    }
}