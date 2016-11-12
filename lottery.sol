
pragma solidity ^0.4.4;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

contract lottery is usingOraclize{
    address private owner;
    uint public constant ticketPrice = 100 finney;
    uint public constant maxNumber = 50;
    uint public revealedDate;
    uint public currentGameIndex = 0;
    
    struct ticket{
        uint guess;
        bytes32 hashValue;
        address playerAddress;
        bool valid; // indicate if this ticket is valid
    }
    
    struct round {
        mapping(uint => ticket) tickets;
        uint ticketsCount;
        uint hitNumber;
        bool revealed;
        bytes32 oraclizeId;
        uint prize;
    }
    round[] public rounds;
    
    mapping(address => uint) pendingWithdrawals;
    
    // modifiers
    modifier onlyOwner() { if (owner != msg.sender) { throw; } _; }
    modifier noEther() { if (msg.value > 0) { throw; } _; }
    
    // events
    event OnGameStart(uint round);
    event OnGameEnd(uint hitNumber);
    event OnHitNumberGenerated(uint hitNumber);
    event OnTicketBought(uint count);

    // constructor
    function lottery(){
        owner = msg.sender;
    }
    
    // owner call this function to start a new round
    function newRound() onlyOwner{
        rounds.length++;
        currentGameIndex = rounds.length - 1;
        rounds[currentGameIndex].ticketsCount = 0;
        rounds[currentGameIndex].hitNumber = 0;
        rounds[currentGameIndex].revealed = false;
        rounds[currentGameIndex].oraclizeId = 0;
        if(currentGameIndex >= 1){
            // start from the second round, tranfser previous round's prize to current round if any
            rounds[currentGameIndex].prize = rounds[currentGameIndex-1].prize;
        }else{
            rounds[currentGameIndex].prize = 0;
        }
        OnGameStart(currentGameIndex);
    }
    
    // owner call this to end a round and send prize to winner
    function endRound() onlyOwner{
        if(!rounds[currentGameIndex].revealed) throw;
        address[] winners;
        for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].valid == true &&
                rounds[currentGameIndex].tickets[i].guess == rounds[currentGameIndex].hitNumber){
                winners.push(rounds[currentGameIndex].tickets[i].playerAddress);
            }
        }
        // %10 of the pot goes to owner
        var commission = rounds[currentGameIndex].ticketsCount * ticketPrice / 10;
        // rest is the prize
        rounds[currentGameIndex].prize = rounds[currentGameIndex].ticketsCount * ticketPrice - commission;
        
        if(winners.length > 0){
            var share = rounds[currentGameIndex].prize / winners.length;
            for(i = 0; i < winners.length; i++){
                pendingWithdrawals[winners[i]] += share;
            }
        }
        
        // owner has the commision
        pendingWithdrawals[owner] += commission;
        OnGameEnd(rounds[currentGameIndex].hitNumber);
    }
    
    function buyTicket(bytes32 hash)
    payable
    {
        uint value = msg.value;
        if(value < ticketPrice){
            throw;
        }
        for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].playerAddress == msg.sender){
                // the player has bought a ticket
                throw;
            }
        }
        if(value > ticketPrice){
            // mark exceeding value as withdraw
            pendingWithdrawals[msg.sender] += value - ticketPrice;
        }
        rounds[currentGameIndex].prize += value;
        rounds[currentGameIndex].tickets[rounds[currentGameIndex].ticketsCount] = ticket(0, hash, msg.sender, false);
        rounds[currentGameIndex].ticketsCount++;
        OnTicketBought(rounds[currentGameIndex].ticketsCount);
    }

    function reveal()
    {
        getRandom();
    }

    function getRandom(){
        rounds[currentGameIndex].oraclizeId = oraclize_query(0, "WolframAlpha", "random number between 1 and 6");
    }

    function __callback(bytes32 _id, string _result) {
       if (rounds[currentGameIndex].revealed) throw;
       if (rounds[currentGameIndex].oraclizeId ==0 || rounds[currentGameIndex].oraclizeId != _id) throw;
       rounds[currentGameIndex].revealed = true;
       revealedDate = now;
       rounds[currentGameIndex].hitNumber = parseInt(_result,10);
       OnHitNumberGenerated(rounds[currentGameIndex].hitNumber);
    }
    
    // player call to verify their numbers
    function verifyNumber(uint number) noEther {
    for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].playerAddress == msg.sender){
                if(number > maxNumber){
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
                if(number <= 0){
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
                var toHash = uint(msg.sender) + number;
                if(rounds[currentGameIndex].tickets[i].hashValue == sha3(toHash)){
                    rounds[currentGameIndex].tickets[i].valid = true;
                    rounds[currentGameIndex].tickets[i].guess = number;
                }else{
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
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
    
    // functions not modifying the state of contract
    function generateHash(uint number) constant returns(bytes32 result){
        if(number > maxNumber){
            throw;
        }
        if(number <= 0){
            throw;
        }
        var toHash = uint(msg.sender) + number;
        return sha3(toHash);
    }
}
