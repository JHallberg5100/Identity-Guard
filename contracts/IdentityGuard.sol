pragma solidity ^0.4.4;
contract IdentityGuard{
  address owner;
  uint public numPersons;

  mapping (uint => Person) Clients;
  struct CreditCard {
    bytes32 bankName;
    uint cardNum;
    uint securityNum;
    uint expDate;
  }


  struct LoginInformation{
    bytes32 websiteName;
    bytes32 username;
    bytes32 password;
  }

  struct Person{
    address clientAddress;
    bytes32 firstName;
    bytes32 lastName;
    uint numLogins;
    uint numCreditCards;

    mapping ( uint => LoginInformation) Logins;

    mapping (uint => CreditCard) Cards;
  }

  function IdentityGuard(){
    owner = msg.sender;
    numPersons = 0;
  }

  function newPerson(bytes32 fn, bytes32 ln) returns (uint personId) {
      personId = numPersons++;
      Clients[personId] = Person(msg.sender,fn,ln,0,0);
  }

  function newCard(bytes32 bankName, uint cardNum, uint securityNum, uint expDate, uint PersonId) returns (uint cardId){
    Person p = Clients[PersonId];
    p.numCreditCards += 1;
    cardId = p.numCreditCards;
    p.Cards[cardId] = CreditCard(bankName,cardNum,securityNum,expDate);
  }

  function newLogin(bytes32 name, bytes32 u_name, bytes32 pass, uint PersonId) returns (uint loginId){
    Person p = Clients[PersonId];
    p.numLogins += 1;
    loginId = p.numLogins;
    p.Logins[loginId] = LoginInformation(name,u_name,pass);
  }

  function returnPerson(uint personId) constant returns (bytes32 firstName, bytes32 lastName){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      firstName = p.firstName;
      lastName = p.lastName;
    }
    else{
      firstName = "No";
      lastName = "No";
    }
  }

  function returnCard(uint personId, uint cardId) constant returns (bytes32 bankName, uint cardNum, uint securityNum, uint expDate){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      CreditCard c = p.Cards[cardId];
      bankName = c.bankName;
      cardNum = c.cardNum;
      securityNum = c.securityNum;
      expDate = c.expDate;
    }
    else {
      bankName = "Invalid";
      cardNum = 0;
      securityNum = 0;
      expDate = 0;
    }
  }
  function returnLogin(uint personId,uint loginId) constant returns (bytes32 websiteName, bytes32 username, bytes32 password){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      LoginInformation i = p.Logins[loginId];
      websiteName = i.websiteName;
      username = i.username;
      password = i.password;
    }
    else{
      websiteName = "Invalid";
      username = "Invalid";
      password = "Invalid";
    }
  }

  function returnCardNumber(uint personId) constant returns (uint totalCards){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      totalCards = p.numCreditCards;
    }
    else{
      totalCards = 0;
    }
  }

  function returnCardName(uint personId, uint cardNum) constant returns (bytes32 bankName){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      CreditCard c = p.Cards[cardNum];
      bankName = c.bankName;
    }
    else{
      bankName = "Invalid query";
    }
  }

  function returnLoginNumber(uint personId) constant returns (uint totalLogins){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      totalLogins = p.numLogins;
    }
    else{
      totalLogins = 0;
    }
  }

  function returnLoginName(uint personId, uint LoginNum) constant returns (bytes32 siteName){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      LoginInformation c = p.Logins[LoginNum];
      siteName = c.websiteName;
    }
    else{
      siteName = "Invalid query";
    }
  }

    /*function returnCards(uint personId) constant returns (bytes32[15] allCards){
      Person p = Clients[personId];
      if (p.clientAddress == msg.sender || owner == msg.sender){
        for (var i = 0; i <= p.numCreditCards; i++){
          CreditCard c = p.Cards[i];
          allCards.push(c.bankName);
        }
      }
      else{
        allCards.push("Invalid");
      }
    }*/
}
