// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract event_org {
    struct Event {
        uint price;
        string name;
        
        uint date;
        uint ticketcount;
        uint ticketremain;
        // mapping(address => uint) attendee; 
    }
    address public manager;
    constructor(){
        manager=msg.sender;
    }
    
    mapping(uint=>Event) public events;
    uint public nextId;
    mapping(address=>mapping(uint=>uint)) public tickets;    // represent( attendee => eventid , no. of tickets) as a 2D array

    function createEvent(string memory name,uint date,uint price, uint ticketcount) external{
        require(date>block.timestamp,"you can organize event for future date");
        require(ticketcount>0);
        require(msg.sender==manager);
        events[nextId]= Event(price,name,date,ticketcount,ticketcount);
        nextId++;
    }

    function buyticket(uint id , uint quantity) public payable{
        require(events[id].date!=0 ,"this event doesnot exist");
        require(block.timestamp<events[id].date);
        Event storage _event = events[id];    // not necessary to do
        require(msg.value==(_event.price*quantity),"ether is not enough");
        require(_event.ticketremain>=quantity,"not enough ticket");
        events[id].ticketremain =  events[id].ticketremain-quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferticket(uint eventId,uint quantity,address to) public{
        require(events[eventId].date!=0 ,"this event doesnot exist");
        require(block.timestamp<events[eventId].date);
        require(tickets[msg.sender][eventId]>=quantity , "you donot have sufficient tickets");
        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId]+= quantity;
    }
}
