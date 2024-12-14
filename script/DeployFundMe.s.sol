// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./help.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelpConfig confg = new HelpConfig();
        address priceAdress = confg.ss_priceFeed();
        vm.startBroadcast();
        FundMe fundme = new FundMe(priceAdress);
        vm.stopBroadcast();
        return fundme;
    }
}
