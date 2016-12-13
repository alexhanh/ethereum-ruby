require 'spec_helper'

describe Ethereum do

  GREETER_BIN = '60606040526040516102563803806102568339810160405280510160008054600160a060020a031916331790558060016000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1060a057805160ff19168380011785555b50608f9291505b8082111560cd5760008155600101607d565b505050610185806100d16000396000f35b828001600101855582156076579182015b82811115607657825182600050559160200191906001019060b1565b509056606060405260e060020a600035046341c0e1b58114610029578063cfae321714610070575b610002565b34610002576100de6000543373ffffffffffffffffffffffffffffffffffffffff9081169116141561014e5760005473ffffffffffffffffffffffffffffffffffffffff16ff5b3461000257604080516020818101835260008252600180548451600282841615610100026000190190921691909104601f81018490048402820184019095528481526100e094909283018282801561017b5780601f106101505761010080835404028352916020019161017b565b005b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f1680156101405780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b565b820191906000526020600020905b81548152906001019060200180831161015e57829003601f168201915b505050505090509056'

  MORTAL_BIN = '606060405260008054600160a060020a0319163317905560648060226000396000f3606060405260e060020a600035046341c0e1b58114601c575b6002565b3460025760606000543373ffffffffffffffffffffffffffffffffffffffff9081169116141560625760005473ffffffffffffffffffffffffffffffffffffffff16ff5b005b56'

  MORTAL_ABI = '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"inputs":[],"type":"constructor"}]'
  
  GREETER_ABI = '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"type":"constructor"}]'


  before(:all) do
    @contract_path = "#{Dir.pwd}/spec/fixtures/greeter.sol"
  end

  it "compiles contract" do
    contract = Ethereum::Solidity.new.compile(@contract_path)
    expect(contract["greeter"]["abi"].strip).to eq GREETER_ABI
    expect(contract["mortal"]["abi"].strip).to eq MORTAL_ABI
    expect(contract["greeter"]["bin"]).to eq GREETER_BIN
    expect(contract["mortal"]["bin"]).to eq MORTAL_BIN
  end

  it "raises ComplicationError if there is a compilation error" do
    expect { Ethereum::Solidity.new.compile("#{Dir.pwd}/spec/fixtures/ContractWithError.sol") }.to raise_error(Ethereum::CompilationError, /.*Error: Identifier not found or not unique.*/)
  end

  it "raises SystemCallError if can't run solc" do
    expect { Ethereum::Solidity.new('no_solc').compile(@contract_path) }.to raise_error(SystemCallError)
  end
  
end
