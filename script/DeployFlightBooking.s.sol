// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FlightBooking} from "../src/FlightBooking.sol";

contract DeployFlightBooking is Script {
    function run() external {
        vm.startBroadcast();
        new FlightBooking(10);
        vm.stopBroadcast();
    }
}
