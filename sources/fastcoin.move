module fastcoin::fastcoin {
    use std::signer;
    use std::string;
    use std::string::String;
    use std::vector;
    use aptos_std::type_info;
    use aptos_framework::account::{Self, SignerCapability};
    use aptos_framework::aptos_account;
    use aptos_framework::coin;
    use aptos_framework::coin::{MintCapability, BurnCapability, FreezeCapability};
    use aptos_framework::resource_account;

    /// Only the coin signer is eligible for initializing the coin
    const ERR_NOT_COIN_SIGNER: u64 = 0;

    /// The coin is already registered under fastcoin.
    const ERR_COIN_REGISTERED: u64 = 1;

    /// The coin is not yet registered under fastcoin.
    const ERR_COIN_NOT_REGISTERED: u64 = 2;

    struct FastCoin has key {
        signer_cap: SignerCapability,
        registered_coins: vector<String>
    }

    struct Capabilities<phantom CoinType> has key {
        mint_cap: MintCapability<CoinType>,
        burn_cap: BurnCapability<CoinType>,
        freeze_cap: FreezeCapability<CoinType>
    }

    fun init_module(resource: &signer) {
        move_to(resource, FastCoin {
            signer_cap: resource_account::retrieve_resource_account_cap(resource, @deployer),
            registered_coins: vector::empty()
        });
    }

    public entry fun init_coin<CoinType>(coin_signer: &signer, name: vector<u8>, symbol: vector<u8>, decimals: u8, monitor_supply: bool) acquires FastCoin {
        assert!(!is_registered<CoinType>(), ERR_COIN_REGISTERED);
        assert!(signer::address_of(coin_signer) == type_info ::account_address(&type_info::type_of<CoinType>()), ERR_NOT_COIN_SIGNER);

        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<CoinType>(
            coin_signer,
            string::utf8(name),
            string::utf8(symbol),
            decimals,
            monitor_supply
        );

        let resource_signer = &get_resource_signer();
        move_to(resource_signer, Capabilities<CoinType> { mint_cap, burn_cap, freeze_cap} );

        let fastcoin = borrow_global_mut<FastCoin>(signer::address_of(resource_signer));
        vector::push_back(&mut fastcoin.registered_coins, type_info::type_name<CoinType>());

        coin::register<CoinType>(resource_signer);
    }

    public entry fun mint_to<CoinType>(to: address, amount: u64) acquires Capabilities {
        assert!(is_registered<CoinType>(), ERR_COIN_REGISTERED);

        aptos_account::deposit_coins<CoinType>(to, coin::mint(amount, &borrow_capabilities<CoinType>().mint_cap));
    }

    #[view]
    public fun registered_coins(): vector<String> acquires FastCoin {
        let fastcoin = borrow_global<FastCoin>(get_resource_address());
        fastcoin.registered_coins
    }

    #[view]
    public fun is_registered<CoinType>(): bool {
        exists<Capabilities<CoinType>>(get_resource_address())
    }

    inline fun borrow_capabilities<CoinType>(): &Capabilities<CoinType> {
        borrow_global<Capabilities<CoinType>>(get_resource_address())
    }

    fun get_resource_signer(): signer acquires FastCoin {
        let FastCoin { signer_cap, registered_coins: _ } = borrow_global<FastCoin>(get_resource_address());
        account::create_signer_with_capability(signer_cap)
    }

    inline fun get_resource_address(): address {
        @fastcoin
    }
}
