// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DefaultFundMe.s.sol";
import {FundFundeMe,WithdrawFundMe} from "../../script/interactions.s.sol";

contract FundMeTestintegration is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 10000 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
         fundme = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
        require(address(fundme) != address(0), "FundMe deployment failed");
    }

    function testuserCanFundInteractions() public {
        FundFundeMe fund = new FundFundeMe();
       
        fund.fundFundeMe(address(fundme));

        WithdrawFundMe withdraw = new WithdrawFundMe();
        withdraw.withdrawFundMe(address(fundme));
        assertEq(address(fundme).balance, 0);
        
       
    }   
}