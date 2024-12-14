// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggreator.sol";

contract HelpConfig is Script {
    PriceFeed public ss_priceFeed;
    uint8 public constant _decimals = 8;
    int256 public constant _initialAnswer = 2000e8;
    struct PriceFeed {
        address priceAdress;
    }

    constructor() {
        if (block.chainid == 11155111) {
            ss_priceFeed = GetSepolia();
        } else if (block.chainid == 1) {
            ss_priceFeed = GetEher();
        } else {
            ss_priceFeed = GetAnvil();
        }
    }

    function GetSepolia() public pure returns (PriceFeed memory) {
        PriceFeed memory sepolia = PriceFeed({
            priceAdress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepolia;
    }

    function GetEher() public pure returns (PriceFeed memory) {
        PriceFeed memory eth = PriceFeed({
            priceAdress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return eth;
    }

    function GetAnvil() public returns (PriceFeed memory) {
        if (ss_priceFeed.priceAdress != address(0)) {
            return ss_priceFeed;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            _decimals,
            _initialAnswer
        );
        vm.stopBroadcast();
        PriceFeed memory anvil = PriceFeed({
            priceAdress: address(mockPriceFeed)
        });

        return anvil;
    }
}
