pragma solidity ^0.8.25;

//import lib from std lib
import "forge-std/Test.sol";
import "forge-std/console2.sol";

//import contract to test
import "../src/PoolStack.sol";

contract TestPoolStack is Test{
    //init contract
    PoolStack poolStack;
    //event for deposit
    event Deposit(address indexed _from, address indexed _to, uint256 _amount);
    //event for without
    event Without(address indexed _from, address indexed _to, uint256 _amount);
 
    function setUp() external {
        poolStack = new PoolStack(
            ["ETH", "SOL"],
            9,
            "1 year",
            60000
        );
    }

    //test the importants features
    function test_goStackedETH() external{
        vm.pauseGasMetering();
        payable(address(poolStack)).transfer(1e8);
        uint256 value = poolStack.getBalanceAddress(address(this));
        assertEq(value, 1e8);
    }

    function test_withoutETH() external noGasMetering {
        //send ETH
        payable(address(poolStack)).transfer(1e8);

        //without ETH
        //vm.expectEmit(true, true, false, true);
        //emit Without(address(poolStack), address(this), 1e8);
        bool result = poolStack.withoutETH(payable(address(this)));
        assertEq(result, true);
    }

    function test_getClaimRewardETH() external{
        //send ETH
        payable(address(poolStack)).transfer(1e8);

        //get time
        bool check = poolStack.claimRewardETH(payable(address(1)));
        assertEq(check, true);
    }
}
