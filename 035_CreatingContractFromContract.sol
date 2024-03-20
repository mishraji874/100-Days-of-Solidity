// Contract Creation in Solidity
// Solidity, with its expressive syntax, enables developers to create contracts that can generate new instances of contracts during runtime using the `new` keyword. This feature empowers developers to build dynamic and interconnected applications on the Ethereum network.


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Car {
    address public owner;
    string public model;
    address public carAddr;
    constructor(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this);
    }
}

//Explanantion: The `Car` contract has a constructor that takes an owner address and a model string as arguments. It assigns these values to the respective variables and sets the `carAddr` variable to the address of the contract itself.

contract CarFactory {
    Car[] public cars;
    function create(address _owner, string memory _model) public {
        Car car = new Car(_owner, _model);
        cars.push(car);
    }
    function createAndSendEther(address _owner, string memory _model) public payable {
        Car car = (new Car){value: msg.value}(_owner, _model);
        cars.push(car);
    }
    function create2(address _owner, string memory _model, bytes32 _salt) public {
        Car car = (new Car){salt: _salt}(_owner, _model);
        cars.push(car);
    }
    function create2AndSendEther(address _owner, string memory _model, bytes32 _salt) public payable {
        Car car = (new Car){value: msg.value, salt: _salt}(_owner, _model);
        cars.push(car);
    }
    function getCar(uint _index) public view returns (address owner, string memory model, address carAddr, uint balance) {
        Car car = cars[_index];
        return (car.owner(), car.model(), car.carAddr(), address(car).balance);
    }
}


//Explanation: The `CarFactory` contract maintains an array of `Car` contracts called `cars`. It provides different functions to create cars using distinct techniques, including the basic creation method, creation with Ether transfer, deterministic creation using `create2`, and a combination of Ether transfer and `create2`. The `getCar` function retrieves details of a car at a given index in the `cars` array.


/*
Exploring Different Techniques

1. Basic Contract Creation: The `create` function demonstrates the simplest approach to create new contracts. It uses the `new` keyword and passes the necessary arguments to the `Car` constructor. The newly created car contract is then added to the `cars` array.

2. Contract Creation with Ether Transfer: The `createAndSendEther` function allows the creation of car contracts while simultaneously transferring Ether. By using the `value` keyword, developers can specify the amount of Ether to send along with the creation transaction. This technique is useful when the newly created car contract needs to have an initial balance.

3. Deterministic Contract Creation with create2: Solidity version 0.8.0 introduced the `create2` feature, which enhances contract creation with determinism. The `create2` function in the `CarFactory` contract demonstrates this technique. It takes an additional `bytes32` argument called `_salt`, which ensures the resulting contract address is deterministic and avoids potential collisions.

4. Contract Creation with Ether Transfer and create2: The `create2AndSendEther` function combines both Ether transfer and the `create2` feature. It allows developers to create contracts with custom salt values while simultaneously transferring Ether to the newly created contract.
*/