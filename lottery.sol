
pragma solidity ^0.4.0;

contract lottery{
    address private owner;
    uint public constant ticketPrice = 100 wei;
    uint public constant maxNumber = 3;
    uint public currentRoundIndex = 0;
    
    struct ticket{
        uint guess; // 0 before player verify
        bytes32 hashValue; // stored, every player can see it all the time
        address playerAddress; // 0 before player verify it
        bool valid; // indicate if this ticket is valid, false before player verify it
    }
    
    struct round {
        mapping(uint => ticket) tickets;
        uint ticketsCount;
        uint hitNumber;
        bool revealed;
        uint prize;
        bool soldOut;
        uint beforeEnd;
    }
    //round[] public rounds;
    mapping(uint => round) public rounds;
    mapping(address => uint) pendingWithdrawals;
    
    // events
    event OnGameStart(uint round);
    event OnGameEnd(uint hitNumber);
    event OnVerified(uint number);
    event OnTicketBought(uint count);
    event OnSoldout(uint round, uint beforeEnd);
    event OnException(string message);

    // modifiers
    modifier onlyOwner() { if (owner != msg.sender) { OnException("not owner"); throw; } _; }
    modifier noEther() { if (msg.value > 0) { OnException("should no ether"); throw; } _; }
    
    // constructor
    function lottery(){
        owner = msg.sender;
    }
    
    // owner call this function to start a new round
    function newRound() onlyOwner{
        if(currentRoundIndex >= 1){
            // start from the second round, tranfser previous round's prize to current round if any
            rounds[currentRoundIndex] = round(0,0,false,rounds[currentRoundIndex-1].prize,false, 0);
        }else{
            rounds[currentRoundIndex] = round(0,0,false,0,false,0);
        }
        OnGameStart(currentRoundIndex);
        currentRoundIndex++;
    }
    
    // owner call this to end a round and send prize to winner
    // and calculate commission to himself
    function endRound() onlyOwner{
        if(!rounds[currentRoundIndex].revealed) throw;
        if(now < rounds[currentRoundIndex].beforeEnd) throw;
        mapping(uint => address) winners;
        uint winnerCount = 0;
        for(uint i = 0; i < rounds[currentRoundIndex].ticketsCount; i++){
            if(rounds[currentRoundIndex].tickets[i].valid == true &&
                rounds[currentRoundIndex].tickets[i].guess == rounds[currentRoundIndex].hitNumber){
                winners[winnerCount] =  rounds[currentRoundIndex].tickets[i].playerAddress;
                winnerCount++;
            }
        }
        // %10 of the pot goes to owner
        var commission = rounds[currentRoundIndex].ticketsCount * ticketPrice / 10;
        // rest is the prize
        rounds[currentRoundIndex].prize = rounds[currentRoundIndex].ticketsCount * ticketPrice - commission;
        
        if(winnerCount > 0){
            var share = rounds[currentRoundIndex].prize / winnerCount;
            for(i = 0; i < winnerCount; i++){
                pendingWithdrawals[winners[i]] += share;
            }
        }
        
        // owner has the commision
        pendingWithdrawals[owner] += commission;
        OnGameEnd(rounds[currentRoundIndex].hitNumber);
    }

    function soldOut(uint time) onlyOwner{
        rounds[currentRoundIndex].soldOut = true;
        rounds[currentRoundIndex].beforeEnd = now + time;
        OnSoldout(currentRoundIndex, rounds[currentRoundIndex].beforeEnd);
    }
    
    function buyTicket(bytes32 hash)
    payable
    {
        if(rounds[currentRoundIndex].soldOut){
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
        rounds[currentRoundIndex].prize += value;
        rounds[currentRoundIndex].tickets[rounds[currentRoundIndex].ticketsCount] = ticket(0, hash, 0, false);
        rounds[currentRoundIndex].ticketsCount++;
        OnTicketBought(rounds[currentRoundIndex].ticketsCount);
    }

    function reveal()
    {
        uint result = 0;
        for(uint i = 0; i < rounds[currentRoundIndex].ticketsCount; i++){
            if(rounds[currentRoundIndex].tickets[i].valid){
                result = result ^ rounds[currentRoundIndex].tickets[i].guess;
            }
        }
       result = result%3+1;
       rounds[currentRoundIndex].revealed = true;
       rounds[currentRoundIndex].hitNumber = result;
       endRound();
    }
    
    // player call to verify their numbers
    function verifyNumber(uint number, uint random) noEther {
        bytes32 thisHash = sha3(msg.sender, number, random);
        for(uint i = 0; i < rounds[currentRoundIndex].ticketsCount; i++){
            if(rounds[currentRoundIndex].tickets[i].hashValue == thisHash){
                if(number > maxNumber){
                    rounds[currentRoundIndex].tickets[i].valid = false;
                    return;
                }
                if(number <= 0){
                    rounds[currentRoundIndex].tickets[i].valid = false;
                    return;
                }
                rounds[currentRoundIndex].tickets[i].guess = number;
                rounds[currentRoundIndex].tickets[i].playerAddress = msg.sender;
                rounds[currentRoundIndex].tickets[i].valid = true;
                OnVerified(number);
            }
        }
    }

    function checkBalance() constant returns(uint balance){
        balance = pendingWithdrawals[msg.sender];
        return balance;
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
    function generateHash(uint number, uint random) constant returns(bytes32 result){
        if(number > maxNumber){
            throw;
        }
        if(number <= 0){
            throw;
        }
        return sha3(msg.sender, number, random);
    }

    function getOwner() constant returns(address result){
        return owner;
    }

    function getCurrentRound() constant returns(uint round){
        return currentRoundIndex;
    }

    function checkTicket() constant returns(uint number) {
        for(uint i = 0; i < rounds[currentRoundIndex].ticketsCount; i++){
            if(rounds[currentRoundIndex].tickets[i].playerAddress == msg.sender){
                return rounds[currentRoundIndex].tickets[i].guess;
            }
        }
    }
}
