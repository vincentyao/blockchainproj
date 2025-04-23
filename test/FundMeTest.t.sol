// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DefaultFundMe.s.sol";


contract FundMeTest is Test {
    FundMe fundme;
    address  USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 10000 ether;


    function setUp() external {
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);   
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
        require(address(fundme) != address(0), "FundMe deployment failed");


    }

    function testdemo() public {
        assertEq(fundme.MINIMUM_USD(), 5 * 10 ** 18);

    }

    function testOwnerIsMsgSender() public {
        console.log( msg.sender);
        console.log( fundme.i_owner());
        assertEq(fundme.i_owner(), msg.sender);
    }

    function testVersion() public {
        uint256 version = fundme.getVersion();
        console.log(version);
        assertEq(version, 4);
    }
    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testFundUpdatesFundeDataStructure()public{

                vm.prank(USER);
                fundme.fund{value:SEND_VALUE}();
                uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
                assertEq(amountFunded, SEND_VALUE);


    }

    

}