// Linking Libraries: Unleashing Their Full Potential! 
//If all the functions in a library are marked as `internal`, the library is embedded directly into the contract. However, if any function is marked as `public` or `external`, the library must be deployed separately and then linked to the contract before deployment. This flexibility gives libraries the power to extend the capabilities of your contracts!


//A Math Library Example: Simplifying Complex Calculations! 

library Math {
    function sqrt(uint y) internal pure returns (uint z) {
        // Square root calculation logic
        // …
    }
}

contract TestMath {
    function testSquareRoot(uint x) public pure returns (uint) {
        return Math.sqrt(x);
    }
}

//Explanation: In this example, the Math library provides a convenient `sqrt()` function that calculates the square root of a given unsigned integer. By embedding this library into our contracts, we can easily perform complex calculations without duplicating code and compromising readability.



//Array Manipulation with Libraries: Say Goodbye to Gaps! 

library Array {
    function remove(uint[] storage arr, uint index) public {
        // Array element removal and reorganization logic
        // …
    }
}

contract TestArray {
    using Array for uint[];
    uint[] public arr;
    function testArrayRemove() public {
        // Test function demonstrating array removal
        // …
    }
}

//Explanation: In this example, the `Array` library defines a handy `remove()` function that takes an array and an index as parameters. It gracefully removes the element at the specified index and reorganizes the array to close any gaps. By leveraging this library, you can efficiently manage and manipulate arrays in your contracts, simplifying your code and optimizing gas usage. 


/*
Benefits of Using Libraries: Unlocking Their Potential!

🔹 Code Reusability: Libraries enable you to write modular and reusable code, reducing duplication and improving code quality. ♻️🔄

🔹 Gas Efficiency: By separating reusable code into libraries, you can save gas costs by avoiding code duplication in multiple contracts. 💨💰

🔹 Code Organization: Libraries help in organizing your codebase, making it more maintainable and easier to understand. 🗂️📚

🔹 Upgradability: Libraries empower you to upgrade the logic of your contracts without affecting stored data, allowing for bug fixes and new feature additions. 🚀🔧
*/