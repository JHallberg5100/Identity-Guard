pragma solidity ^0.4.4;
contract IdentityBlok{
  address owner;
  uint public numPersons;

  mapping (uint => Person) Clients;
  struct DataLocker{
    bytes32 DataType;
    bytes32 LockerName;
    bytes RawData;
  }

  struct Person{
    address clientAddress;
    bytes32 firstName;
    bytes32 lastName;
    uint numDataLockers;
    bytes pubKey;

    mapping ( uint => DataLocker) Locker;
  }


  function IdentityBlok(){
    owner = msg.sender;
    numPersons = 0;
  }

  function newPerson(bytes32 fn, bytes32 ln, bytes key) returns (uint personId) {
      personId = numPersons++;
      Clients[personId] = Person(msg.sender,fn,ln,0,key);
  }

  function newDataLocker(bytes32 DataType, bytes32 LockerName, bytes RawData, uint PersonId) returns (uint LockerId){
    Person p = Clients[PersonId];
    p.numDataLockers += 1;
    LockerId = p.numDataLockers;
    p.Locker[LockerId] = DataLocker(DataType, LockerName, RawData);
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

  function returnKey(uint personId) constant returns (bytes keyValue){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      keyValue = p.pubKey;
    }
    else{
      keyValue = "Invalid";
    }
  }

  function openLocker(uint personId, uint LockerId) constant returns (bytes32 DataType, bytes32 LockerName, bytes RawData){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      DataLocker c = p.Locker[LockerId];
      DataType = c.DataType;
      LockerName = c.LockerName;
      RawData = c.RawData;
    }
    else {
      DataType = "Invalid";
      LockerName = "Invalid";
      RawData = "Invalid";
    }
  }

  function returnLockers(uint personId) constant returns (uint totalLockers){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      totalLockers = p.numDataLockers;
    }
    else{
      totalLockers = 0;
    }
  }

  function returnLockerType(uint personId, uint LockerId) constant returns (bytes32 LockerName){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      DataLocker l = p.Locker[LockerId];
      LockerName = l.DataType;
    }
    else{
      LockerName = "Invalid";
    }
  }


  function returnLockerName(uint personId, uint LockerId) constant returns (bytes32 LockerName){
    Person p = Clients[personId];
    if (p.clientAddress == msg.sender || owner == msg.sender){
      DataLocker l  = p.Locker[LockerId];
      LockerName= l.LockerName;
    }
    else{
      LockerName = "Invalid query";
    }
  }


}
