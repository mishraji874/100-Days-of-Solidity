// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Loops {

    // in this function 'i' to 0 and set the condition i < 10. the loop iterates as long as the condition holds true. wwithin the loop, we have conditional statements. when i == 3, then 'continue' statement skips to the next iteration. on the other hand, when i == 5, the 'break' statement terminates the loop when i == 5.
    function forLoop() public {
        //for loop
        for(uint i = 0; i < 10; i++) {
            if(i == 3) {
                // skip to next iteration wwith continue
                continue;
            }
            if(i == 5) {
                //exit loop wwith break
                break;
            }
        }
    }


    // in this example, a variable declared as i and initalize to 0. The while loop condition i < 10 is evaluated before each iteration. As long as the condition holds true, the code block within the loop is executed. in this case, we increment 'i' by 1 in each iteration. the loop terminates when 'i' become equal to or greater than 10.
    function whileLoop() public {
        //while loop
        uint i;
        while(i < 10) {
            i++;
        }
    }
}