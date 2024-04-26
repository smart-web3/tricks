pragma solidity ^0.8.25;

//import lib from std lib
import "forge-std/Test.sol";

//import contract to test
import "../src/PoolStack.sol";

contract TestPoolStack is Test{
    //init contract
    PoolStack poolStack;
    
    function setUp() external {
        poolStack = new PoolStack(
            ["ETH", "SOL"],
            9,
            "1 year"
        );
    }

    function test_foundTime() external view{
        string memory time = poolStack.getTime();
        assertEq(time, "1 year");
    }
}
