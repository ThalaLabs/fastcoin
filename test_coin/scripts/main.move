script {
    use std::option;
    use parliament::vetoken_dao;
    use test_coin::test_coin::TestCoin;

    fun main(account: &signer) {
        // vetoken_dao::create_vetoken_dao<TestCoin>(
        //     account,
        //     b"",
        //     vector<address>[],
        //     0,
        //     300,
        //     option::some(1),
        //     option::none<u64>()
        // );

        // vetoken_dao::create_proposal<TestCoin>(
        //     account,
        //     @0x202d17d4d40fde81a1ebf3daf063dc0d273978e7a379eb9cd210047a1aee13cf,
        //     0,
        //     b"",
        //     x"a11ceb0b060000000601000203020a050c11071d2908462006662e0000000102030000020400000002050c0305030a02010c03060c050a020a7061726c69616d656e74077265736f6c7665157365745f64616f5f646f63756d656e745f6861736814e0d04191830a1ee78ae28e9d0ad47a045983d111d7ed577e7dcb5ce9af64050520202d17d4d40fde81a1ebf3daf063dc0d273978e7a379eb9cd210047a1aee13cf0a0201000a020504444f43530000010c07000c000a00060000000000000000070111000c010e010b000702110102",
        //     600
        // );

        vetoken_dao::vote<TestCoin>(
            account,
            @0x202d17d4d40fde81a1ebf3daf063dc0d273978e7a379eb9cd210047a1aee13cf,
            0,
            0
        );
    }
}