package com.generatorproject.services;

public class FinalizeContractService {
    private final ContractService contractService = new ContractService();

    public void finalizeDraft(Long contractId, Long actorId) throws Exception {
        contractService.finalizeContract(contractId, actorId);
    }
}
