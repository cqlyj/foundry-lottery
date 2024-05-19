// SPDX-LICENSE-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

contract CreateSubscription is Script {
    function CreateSubscriptionUsingConfig() internal returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (, , address vrfCoordinator, , , , ) = helperConfig
            .activeNetworkConfig();
        return createSubscription(vrfCoordinator);
    }

    function createSubscription(
        address vrfCoordinator
    ) public returns (uint64) {
        // Create a new subscription
        console.log("Creating a new subscription on ChainId: ", block.chainid);

        vm.startBroadcast();

        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator)
            .createSubscription();

        vm.stopBroadcast();
        console.log("Subscription ID: ", subId);
        console.log(
            "Please update the subscription ID in the HelperConfig contract"
        );
        return subId;
    }

    function run() external returns (uint64) {
        return CreateSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3;

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,
            ,
            address vrfCoordinator,
            ,
            uint64 subId,
            ,
            address link
        ) = helperConfig.activeNetworkConfig();

        fundSubscription(vrfCoordinator, subId, link);
    }

    function fundSubscription(
        address vrfCoordinator,
        uint64 subId,
        address link
    ) public {
        console.log("Funding subscription: ", subId);
        console.log("Using vrfCoordinator: ", vrfCoordinator);
        console.log("ChainId:", block.chainid);

        if (block.chainid == 31337) {
            vm.startBroadcast();

            VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription(
                subId,
                FUND_AMOUNT
            );

            vm.stopBroadcast();
        } else {
            vm.startBroadcast();

            LinkToken(link).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subId)
            );

            vm.stopBroadcast();
        }
    }

    function run() external {
        fundSubscriptionUsingConfig();
    }
}
