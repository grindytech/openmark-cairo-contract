use openzeppelin::tests::utils::constants::OWNER;
use openzeppelin::utils::serde::SerializedAppend;
use snforge_std::{declare, ContractClassTrait, start_cheat_caller_address};
use starknet::{
    ContractAddress, contract_address_const, get_tx_info, get_caller_address,
    testing::{set_caller_address}
};
use contracts::{
    Primitives::{Order, OrderType},
    Interface::{
        IOffchainMessageHashDispatcher, IOffchainMessageHashDispatcherTrait, IOffchainMessageHash
    }
};


fn deploy_contract() -> (IOffchainMessageHashDispatcher, ContractAddress) {
    let contract = declare("OpenMark").unwrap();

    let mut constructor_calldata = array![];
    let owner = contract_address_const::<420>();
    constructor_calldata.append_serde(owner);

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    let dispatcher = IOffchainMessageHashDispatcher { contract_address };

    (dispatcher, contract_address)
}


#[test]
#[available_gas(2000000)]
fn get_message_hash_works() {
    let (dispatcher, contract_address) = deploy_contract();

    // This value was computed using StarknetJS
    let message_hash = 0x49a126d54c5d4047784d9d4cf177479dd7812ac887f20746c7b9e56fadba5e;
    let order = Order {
        nftContract: 1.try_into().unwrap(),
        tokenId: 2,
        price: 3,
        salt: 4,
        expiry: 5,
        option: OrderType::Buy,
    };

    start_cheat_caller_address(contract_address, 420.try_into().unwrap());

    let result = dispatcher.get_message_hash(order);

    assert_eq!(result, message_hash,);
}
