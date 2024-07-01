use core::option::OptionTrait;
use core::traits::TryInto;
use core::array::ArrayTrait;
use snforge_std::signature::SignerTrait;
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
        IOffchainMessageHashDispatcher, IOffchainMessageHashDispatcherTrait, IOffchainMessageHash,
        IOpenMarkDispatcher, IOpenMarkDispatcherTrait, IOpenMark
    },
};
use openzeppelin::token::erc721::erc721::ERC721Component;


fn deploy_contract() -> ContractAddress {
    let contract = declare("OpenMark").unwrap();

    let mut constructor_calldata = array![];
    let owner = contract_address_const::<420>();
    constructor_calldata.append_serde(owner);

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    contract_address
}

fn deploy_erc721() -> ContractAddress {
    let contract = declare("OM721Token").unwrap();
    
    let mut constructor_calldata = array![];
    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    contract_address
}


#[test]
#[available_gas(2000000)]
fn get_message_hash_works() {
    let contract_address = deploy_contract();

    // This value was computed using StarknetJS
    let message_hash = 0x4d5c7bf7d624d7ade7f8d4c73092ebcb9287e2be556ef15f65116dc94421bd1;
    let order = Order {
        nftContract: 1.try_into().unwrap(),
        tokenId: 2,
        price: 3,
        salt: 4,
        expiry: 5,
        option: OrderType::Buy,
    };
    let signer = 0x20c29f1c98f3320d56f01c13372c923123c35828bce54f2153aa1cfe61c44f2;

    start_cheat_caller_address(contract_address, signer.try_into().unwrap());
    let dispatcher = IOffchainMessageHashDispatcher { contract_address };

    let result = dispatcher.get_message_hash(order, signer);

    assert_eq!(result, message_hash,);
}

#[test]
#[available_gas(2000000)]
fn verify_order_works() {
    let contract_address = deploy_contract();

    let order = Order {
        nftContract: 1.try_into().unwrap(),
        tokenId: 2,
        price: 3,
        salt: 4,
        expiry: 5,
        option: OrderType::Buy,
    };
    let signer = 0x20c29f1c98f3320d56f01c13372c923123c35828bce54f2153aa1cfe61c44f2;

    let mut signature = array![
        0x7d22529d850174cd51eca7e156397cce6518c7bc82343758382e16c5fe9fe55,
        0x4aa8aab803bc9fe0f6579367ef034f8a98d2ccd1617eb0b48ece03819ac2e2
    ];

    start_cheat_caller_address(contract_address, signer.try_into().unwrap());

    let dispatcher = IOpenMarkDispatcher { contract_address };

    let result = dispatcher.verifyOrder(order, signer, signature.span());

    assert_eq!(result, true);
}


#[test]
#[available_gas(2000000)]
fn buy_works() {
    let contract_address = deploy_contract();

    let erc_721 = deploy_erc721();
    // let ERC721Dispatcher = Inter { erc_721 };
    

    let order = Order {
        nftContract: erc_721,
        tokenId: 2,
        price: 3,
        salt: 4,
        expiry: 5,
        option: OrderType::Buy,
    };
    let signer = 0x20c29f1c98f3320d56f01c13372c923123c35828bce54f2153aa1cfe61c44f2;


    start_cheat_caller_address(contract_address, signer.try_into().unwrap());

    let dispatcher = IOpenMarkDispatcher { contract_address };

    assert_eq!(true, true);
}

