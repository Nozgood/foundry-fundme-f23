// deploy mocks when on a local anvil chain
// keep track of contract address across different chains

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    uint256 public constant SEPOLIA_ETH_CHAIN_ID = 11155111;

    // When i deploy the contract, i check on which chain i am (in function of the chain_id) and i call the correct
    // function
    //  - if chain_id of eth seplia: i set the price feed of eth sepolia
    //  - else: i set the anvil price feed
    constructor() {
        if (block.chainid == SEPOLIA_ETH_CHAIN_ID) {
            activeNetworkConfig = getSepoliaETHConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilETHConfig();
        }
    }

    // I set the price feed on ETH sepolia chain
    function getSepoliaETHConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});

        return sepoliaConfig;
    }

    /*
        flora ma bella
        boubou la poilu
    */

    function getOrCreateAnvilETHConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;
    }
}
