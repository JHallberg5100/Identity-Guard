var MetaCoin = artifacts.require("./MetaCoin.sol");

contract('MetaCoin', function(accounts) {
  it("should put 10000 MetaCoin in the first account", function() {
    return MetaCoin.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var meta;
    var metaCoinBalance;
    var metaCoinEthBalance;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      metaCoinBalance = outCoinBalance.toNumber();
      return meta.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      metaCoinEthBalance = outCoinBalanceEth.toNumber();
    }).then(function() {
      assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var meta;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return meta.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});
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714j
