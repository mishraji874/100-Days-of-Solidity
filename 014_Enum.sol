// Enums
// Enums in Solidity are user-defined types that represent a set of named values. They provide a way to define a limited number of options or states that a variable can take. 🌈 Each option is assigned an implicit ordinal value, starting from zero for the first option and incrementing by one for each subsequent option. Enums are useful when you want to represent a finite set of choices or track the state of an object with a limited number of possible values.


/*
Declaring Enums

To declare an enum in solidity, we have to use the 'enum' keyword by the name of the enum and a list of its possible values in curly braces.
Ex- enum {
    pending,
    shipped,
    accepted,
    rejected,
    cancelled
}
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Enum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Cancelled
    }

    Status public status;
    function get() public view returns (Status) {
        return status;
    }

    function set(Status _status) public {
        status = _status;
    }

    function cancel() public {
        status = Status.Cancelled;
    }

    function reset() public {
        delete status;
    }
}

/* 
Analyzing the Enum Contract
Now, let’s analyze and discuss the different parts of the `Enum` contract and how enums are utilized:

1️⃣ Enum Declaration:
The `Status` enum represents the shipping status of an item and has five possible values: `Pending`, `Shipped`, `Accepted`, `Rejected`, and `Canceled`. 📦

2️⃣ Status Variable:
The `status` variable of type `Status` is declared as public, allowing external access. This variable holds the current shipping status of an item. 📮

3️⃣ Getter Function (get):
The `get` function is a public view function that returns the current value of the `status` variable. It allows external entities to read the shipping status without modifying it. 🔍

4️⃣ Setter Function (set):
The `set` function is a public function that takes a `Status` parameter `_status` and updates the value of the `status` variable to the provided value. This function allows external entities to update the shipping status. 📝

5️⃣ Cancel Function:
The `cancel` function sets the `status` variable to the `Canceled` value of the `Status` enum. It demonstrates how to assign a specific enum value to a variable. 🚫

6️⃣ Reset Function:
The `reset` function uses the `delete` keyword to reset the `status` variable to its default value, which is the first element (`Pending`) of the `Status` enum. 🔄
*/