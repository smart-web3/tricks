// ce contrat de test est destine Roxalex

pragma solidity ^0.8.25;

//import lib from std lib
import "forge-std/Test.sol";
import "forge-std/console2.sol";

//import contract to test
import "../src/ERCTest.sol";

contract TestERC is Test{
     ERCTest ERC;
    
     function setUp() external {
        ERC = new ERCTest("slash", "SL");
        ERC._mint(address(1), 1e8);
    }

    //test the importants features
    function testFuzz_erc(uint256 value) external{
        vm.prank(address(1));
        ERC.approve(address(this), value);
        ERC.transferFrom(address(1), address(this), value);
        
        assertEq(ERC.balanceOf(address(this)), value);
    }
}
