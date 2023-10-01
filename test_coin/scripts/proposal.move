script {
    use parliament::parliament;

    fun resolve() {
        let (dao_address, proposal_id) = (@0x202d17d4d40fde81a1ebf3daf063dc0d273978e7a379eb9cd210047a1aee13cf, 0);
        let next_execution_script_hash = vector<u8>[];
        let dao_signer = parliament::resolve(dao_address, proposal_id, next_execution_script_hash);
        parliament::set_dao_document_hash(&dao_signer, dao_address, b"DOCS");
    }
}