pragma solidity ^0.4.0;

contract lottery{

uint public constant ticketPrice = 100 finney;
uint public constant maxNumber = 50;
uint public gameStart;
    uint public buyEnd;
    uint public revealEnd;
    uint public prize = 0;

    mapping(address => uint[]) public tickets;
    mapping(address => uint) pendingWithdrawals;
    uint[] private numbers;

    modifier onlyBefore(uint _time){if (now >= _time) throw; _;}
    modifier onlyAfter(uint _time){if(now <= _time) throw; _;}

    function ticket(uint _buyTime, uint _revealTime){
        gameStart = now;
        buyEnd = now + _buyTime;
        revealEnd = now + _revealTime;
    }
    
    function buyTicket(uint number)
    payable
    onlyBefore(buyEnd)
    {
        if(number > maxNumber){
            throw;
        }
        uint value = msg.value;
        if(value < ticketPrice){
            throw;
        }
        if(value > ticketPrice){
            // mark exceeding value as withdraw
            pendingWithdrawals[msg.sender] += value - ticketPrice;
        }
        prize += value;
        tickets[msg.sender].push(number);
        numbers.push(number);
    }

    function reveal()
    onlyAfter(buyEnd)
    onlyBefore(revealEnd)
    {
        uint hitValue = calculate();
        uint divider = getShareDivider(hitValue);
        if(divider == 0){
            // no player wins
        }
        uint ticketCount = tickets[msg.sender].length;
        uint hitCount = 0;
        for(uint i = 0; i < ticketCount; i++){
            if(tickets[msg.sender][i] == hitValue){
                hitCount++;
            }
        }
        pendingWithdrawals[msg.sender] += prize * hitCount / divider;
    }

    function calculate() returns (uint hitValue){
        hitValue = 0;
        for(uint i = 0; i < numbers.length; i++){
            hitValue = 5;
        }
    }

    function getShareDivider(uint hitValue) returns (uint divider){
        divider = 0;
        for(uint i = 0; i < numbers.length; i++){
            if(numbers[i] == hitValue){
                divider++;
            }
        }
    }

    function checkBalance() returns(uint balance){
        balance = pendingWithdrawals[msg.sender];
    }

    // withdraw the pending amount
    function withdraw() returns(bool){
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        if(msg.sender.send(amount)){
            return true;
        }else{
            pendingWithdrawals[msg.sender] = amount;
            return false;
        }
    }
}
