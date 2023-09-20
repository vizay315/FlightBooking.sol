// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FlightBooking} from "../src/FlightBooking.sol";

contract FlightBookingTest is Test {
    FlightBooking flightBooking;

    function setUp() external {
        flightBooking = new FlightBooking(10);

        vm.deal(address(flightBooking), 100 ether);
    }

    function testOwnerIsMsgSender() public {
        // console.log(flightBooking.contractOwner());
        // console.log(msg.sender);
        assertEq(flightBooking.contractOwner(), address(this));
    }

    function testTicketPriceIsOneEther() public {
        assertEq(flightBooking.ticketPrice(), 1 ether);
    }

    function testBookTicket() public {
        flightBooking.bookFlightTicket{value: 1 ether}("vijay", 1);
        bool exists = flightBooking.isSeatBooked(1);
        assertTrue(exists);
        assertEq(flightBooking.bookedSeats(), 1);
    }

    function testBookTicketFails() public {
        vm.expectRevert();
        flightBooking.bookFlightTicket("vijay", 1);
    }

    function testCancelTicket() public {
        flightBooking.bookFlightTicket{value: 1 ether}("vijay", 1);
        flightBooking.cancelFlightTicket(0);
        assertEq(flightBooking.bookedSeats(), 0);
        assertEq(flightBooking.isSeatBooked(1), false);
    }
}
