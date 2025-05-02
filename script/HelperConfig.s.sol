// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";
import {console} from "forge-std/console.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
        
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else {
            revert("No config for this network");
        }
    }
    
    function getSepoliaEthConfig()
        public
        pure returns (NetworkConfig memory)
    {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
       
    }

    function getOrCreateAnvilEthConfig()
        public
         returns (NetworkConfig memory)
    {
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        console.log("MockV3Aggregator address:", address(mockV3Aggregator));


        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address( mockV3Aggregator)
        });
        return anvilConfig;


    }
}   