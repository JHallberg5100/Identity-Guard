pragma solidity ^0.4.4;
contract IdentityGuard{
  address owner;
  uint public numPersons;

  mapping (uint => Person) Clients;
  struct CreditCard {
    bytes32 bankName;
    bytes32 fullName;
    bytes32 cardIssuer;
    uint cardNum;
    uint securityNum;
    uint expDate;
  }


  struct LoginInformation{
    bytes32 websiteName;
    bytes32 url;
    bytes32 username;
    bytes32 password;
  }

  struct BankAccount{
    bytes32 bankName;
    uint routingNum;
    uint accountNum;
  }

  struct ID{
    bytes32 IDType;
    uint expDate;
    uint licNum;
  }

  struct Person{
    address clientAddress;
    bytes32 firstName;
    bytes32 lastName;
    uint numLogins;
    uint numCreditCards;
    uint numBankAccounts;
    uint numIDs;
    bytes32 pubKey;

    mapping ( uint => LoginInformation) Logins;
    mapping (uint => CreditCard) Cards;
    mapping (uint => BankAccount) Accounts;
    mapping (uint => ID) IDs;
  }


  function IdentityGuard(){
    owner = msg.sender;
    numPersons = 0;
  }

  function newPerson(bytes32 fn, bytes32 ln, bytes32 key) returns (uint personId) {
      personId = numPersons++;
      Clients[personId] = Person(msg.sender,fn,ln,0,0,0,0, key);
  }

  function newCard(bytes32 bankName, bytes32 fullName, bytes32 cardIssuer ,uint cardNum,uint securityNum, uint expDate, uint PersonId) returns (uint cardId){
    Person p = Clients[PersonId];
    p.numCreditCards += 1;
    cardId = p.numCreditCards;
    p.Cards[cardId] = CreditCard(bankName, fullName, cardIssuer, cardNum,securityNum,expDate);
  }

  function newLogin(bytes32 name, bytes32 url, bytes32 u_name, bytes32 pass, uint PersonId) returns (uint loginId){
    Person p = Clients[PersonId];
    p.numLogins += 1;
    loginId = p.numLogins;
    p.Logins[loginId] = LoginInformation(name, url, u_name,pass);
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

  function returnKey(uint personId) constant returns (bytes32 key){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      key = p.pubKey;
    }
  }

  function returnCard(uint personId, uint cardId) constant returns (bytes32 bankName, bytes32 fullName, bytes32 cardIssuer, uint cardNum, uint securityNum, uint expDate){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      CreditCard c = p.Cards[cardId];
      bankName = c.bankName;
      fullName = c.fullName;
      cardIssuer = c.cardIssuer;
      cardNum = c.cardNum;
      securityNum = c.securityNum;
      expDate = c.expDate;
    }
    else {
      bankName = "Invalid";
      fullName = "Invalid";
      cardIssuer = "Invalid";
      cardNum = 0;
      securityNum = 0;
      expDate = 0;
    }
  }
  function returnLogin(uint personId,uint loginId) constant returns (bytes32 websiteName,bytes32 url, bytes32 username, bytes32 password){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      LoginInformation i = p.Logins[loginId];
      websiteName = i.websiteName;
      url = i.url;
      username = i.username;
      password = i.password;
    }
    else{
      websiteName = "Invalid";
      url = "www.Invalid.com";
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


  function newBankAccount(bytes32 bankName, uint routingNum, uint accountNum, uint personId) returns (uint accountId){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      p.numBankAccounts += 1;
      accountId = p.numBankAccounts;
      p.Accounts[accountId] = BankAccount.new(bankName, routingNum, accountNum);
    }
  }

  function newID(bytes32 type, uint expDate, uint licNum, uint personId) returns (uint IDnum){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      p.numIDs += 1;
      IDnum = p.numIDs;
      p.IDs[IDnum] = ID.new(type, expDate, licNum);
    }
  }

  function returnBankAccount(uint personId, uint accountId) constant returns (bytes32 bankName, uint routingNum, uint accountNum){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      BankAccount a = Accounts[accountId];
      bankName = a.bankName;
      routingNum = a.routingNum;
      accountNum = a.accountNum;
    }
  }

  function returnID(uint personId, uint IDnum) constant returns (bytes32 type, uint expDate, uint licNum){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      ID i = IDs[IDnum];
      type = i.IDType;
      expDate = i.expDate;
      licNum = i.licNum;
    }
  }

  function returnAccountNum(uint personId) constant returns (uint accountNums){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      accountNums = p.numBankAccounts;
    }
  }

  function returnIDNum(uint personId) constant returns (uint idNum){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      idNum = p.numIDs;
    }
  }

  function returnAccountName(uint personId, uint accountId) constant returns (bytes32 name){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      BankAccount a = p.Accounts[accountId];
      name = a.bankName;
    }
  }

  function returnIDName( uint personId, uint IDnum ) constant returns (bytes32 name){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      ID i = p.IDs[IDnum];
      name = i.IDType;
    }
  }
}
