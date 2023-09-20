// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FlightBooking {
    address payable public contractOwner;

    uint256 public totalSeats;
    uint256 public bookedSeats;
    uint256 public constant ticketPrice = 1 ether;

    struct Ticket {
        string PassengerName;
        uint256 SeatNumber;
        bool exists;
    }

    mapping(address => mapping(uint => Ticket)) public tickets;
    mapping(address => uint) public userTicketCount;
    mapping(address => uint256) public balances;
    mapping(uint => bool) public isSeatBooked;

    constructor(uint256 _totalSeats) {
        contractOwner = payable(msg.sender);
        totalSeats = _totalSeats;
        bookedSeats = 0;
    }

    function bookFlightTicket(
        string memory passengerName,
        uint seatNumber
    ) public payable {
        require(msg.value >= ticketPrice, "Insufficient funds");
        require(
            seatNumber > 0 && seatNumber <= totalSeats,
            "Invalid seat number"
        );
        require(!isSeatBooked[seatNumber], "seat already booked");

        balances[msg.sender] += ticketPrice;
        // contractOwner.transfer(ticketPrice);

        bookedSeats++;

        uint ticketId = userTicketCount[msg.sender];
        tickets[msg.sender][ticketId] = Ticket(passengerName, seatNumber, true);
        userTicketCount[msg.sender]++;
        isSeatBooked[seatNumber] = true;
    }

    function cancelFlightTicket(uint ticketId) public payable {
        require(userTicketCount[msg.sender] > 0, "No ticket to cancel");
        require(ticketId < userTicketCount[msg.sender], "Invalid ticketId");

        // Ticket storage ticket = tickets[msg.sender][ticketId];
        require(
            tickets[msg.sender][ticketId].exists == true,
            "ticket does not exist"
        );

        balances[msg.sender] -= ticketPrice;
        (payable(msg.sender).send(ticketPrice), "transfer failed");
        bookedSeats--;

        isSeatBooked[tickets[msg.sender][ticketId].SeatNumber] = false;
        delete tickets[msg.sender][ticketId];
        userTicketCount[msg.sender]--;
    }

    function getOwnerBalance() public view returns (uint) {
        return contractOwner.balance;
    }
}
