transaction = record {
    from = "\<USER_ADDRESS>\";
    to = "\<USER_ADDRESS>\";
    value = 0x0;
    data = vec { <IC_AGENT_PRINCIPAL> };
    gas = 0x989680;
    gas_price = 0xa;
    nonce = 0x0;
}

dfx canister call <evm_canister_principal> --ic send_raw_transaction "(transaction)"

dfx canister call <evm_canister_principal> --ic reserve_address "(<IC_AGENT_PRINCIPAL>, <TRANSACTION_HASH>)"
