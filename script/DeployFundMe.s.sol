// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUSDPriceFeed = helperConfig.activeNetworkConfig();

        // TODO test the HelperConfig by running `forge test --fork-url $SEPOLIA_RPC_URL`
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast();

        return fundMe;
    }
}
