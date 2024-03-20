/*
Inheritance Tree 🌳
Before we embark on our exploration, let’s take a moment to understand the inheritance tree we’ll be working with:

```
A
/ \
B C
\ /
D
```

Here, we have four contracts: A, B, C, and D. Contract A is the parent of both B and C, while contract D inherits from both B and C. This inheritance structure sets the stage for our exploration of calling parent contracts.
*/

/*
Directly Calling Parent Contracts 📞
In Solidity, you have the power to call functions defined in a parent contract directly from a child contract. This allows for code reuse and easy extension of functionality. Let’s examine the provided code samples to understand how this works.

Contract A sets the foundation by defining two functions: `foo()` and `bar()`. It also emits an event called `Log` to log function calls. The `foo()` function emits a log message “A.foo called” when invoked, and the `bar()` function emits a log message “A.bar called”.

Contract B, being a child contract of A, overrides the `foo()` and `bar()` functions. In its overridden `foo()` function, it emits a log message “B.foo called” and invokes the `foo()` function of contract A using `A.foo()`. Similarly, the overridden `bar()` function emits a log message “B.bar called” and invokes the `bar()` function of the parent contract using `super.bar()`.

Contract C, another child contract of A, follows a similar pattern. It overrides the `foo()` and `bar()` functions, emitting log messages specific to C, and calling the `foo()` function of contract A. The overridden `bar()` function emits a log message “C.bar called” and invokes the `bar()` function of the parent contract using `super.bar()`.

Lastly, contract D inherits from both B and C. In contract D, we override the `foo()` and `bar()` functions once again, but this time, we call `super.foo()` and `super.bar()` to invoke the respective functions from the immediate parent contracts.
*/


/*
The Mighty `super` Keyword ⚡
Solidity empowers us with the `super` keyword, which allows for explicit invocation of functions from immediate parent contracts. When using `super`, Solidity ensures that the most derived function (the one overridden in the child contract) is called, followed by subsequent functions in the inheritance hierarchy.

Let’s analyze the behavior of the `foo()` and `bar()` functions in contract D:


function foo() public override(B, C) {
super.foo();
}

function bar() public override(B, C) {
super.bar();
}


In the `foo()` function of contract D, we specify `override(B, C)`. This instructs Solidity to call the overridden `foo()` functions from contracts B and C in that order. By using `super.foo()`, we ensure that the `foo()` function from contract C is called first, followed by the `foo()` function from contract A.

Similarly, in the `bar()` function of contract D, we specify `override(B, C)`. This ensures that the overridden `bar()` functions from contracts B and C are called in the specified order when we use `super.bar()`. The chain of function calls goes from contract C to contract B and finally reaches contract A.
*/