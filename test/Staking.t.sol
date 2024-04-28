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
 
    address owner = address("0x7109709ECfa91a80626fF3989D68f67F5b1DD12D");

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
        vm.
        payable(address(poolStack)).transfer(1e8);
        //without ETH
        //vm.expectEmit(true, true, false, true);
        //emit Without(address(poolStack), address(this), 1e8);
        bool result = poolStack.withoutETH(payable(address(1)));
        vm.resumeGasMetering();
        assertEq(result, true);
    }

    function test_getClaimRewardETH() external{
        //send ETH
        payable(address(poolStack)).transfer(1e8);

        //claim reward
        vm.resumeGasMetering();
        bool check = poolStack.claimRewardETH(payable(address(this)));
        assertEq(check, true);
    }
}
