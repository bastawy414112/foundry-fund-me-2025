// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    address user = makeAddr("bastawy");
    uint256 constant Send_Value = 0.1 ether;
    modifier bastawFund() {
        vm.prank(user);
        fundme.fund{value: Send_Value}();
        _;
    }

    function setUp() external {
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(user, 10e18);
    }

    function testcheckdollars() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOnwerIsMsgSender() public view {
        console.log(fundme.GetOnwer()); // hatl3 al moshkla console.log
        console.log(msg.sender);
        assertEq(fundme.GetOnwer(), msg.sender);
    }

    function testFundMeData() public {
        vm.prank(user); // Set the caller to `user`
        fundme.fund{value: Send_Value}(); // Correctly call the `fund` function
        uint256 funded = fundme.GetAdressOfAmounetFunders(user); // Correct call using the `fundme` instance
        assertEq(funded, Send_Value); // Assert the funded amount is as expected
    }

    function testsendEnoghEther() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testDrawsforOnwer() public bastawFund {
        uint256 startingonwerBalance = fundme.GetOnwer().balance;
        vm.prank(fundme.GetOnwer());
        fundme.withdraw();
        uint256 endingonwerbalance = fundme.GetOnwer().balance;
        assertEq(startingonwerBalance + Send_Value, endingonwerbalance);
    }
}
