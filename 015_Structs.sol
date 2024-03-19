// Structs
// In Solidity, structs allow you to create custom types that group related data together. They are similar to structs or classes in other programming languages. By encapsulating data into a single composite entity, structs help you organize and manage complex data structures within your contracts.

/*
Declaration and Example of Structs

We can declare it using 'struct' keyword.
Ex- struct Todo {
    string text;
    bool completed;
}
*/


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Structs {
    struct Todo {
    string text;
    bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) public {
        todos.push(Todo(_text, false));
        todos.push(Todo({text: _text, completed: false}));
        Todo memory todo;
        todo.text = _text;
        todos.push(todo);
    }


    function get(uint _index) public view returns (string memory text, bool completed) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }


    function updateText(uint _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }


    function toggleCompleted(uint _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}

/*
Explanation: The `get` function allows you to retrieve the text description and completion status of a specific todo item, given its index in the `todos` array. It returns the values as a tuple, which includes the text description and a boolean indicating completion.

The `updateText` function enables you to modify the text description of a todo item. You can pass the index of the item to be updated and the new text as parameters. The function locates the corresponding `Todo` struct in the `todos` array using the index and modifies the `text` member accordingly.

The `toggleCompleted` function toggles the completion status of a todo item. Similar to `updateText`, you provide the index of the item, and the function modifies the `completed` member accordingly. 
*/