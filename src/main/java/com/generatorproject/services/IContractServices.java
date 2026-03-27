package com.generatorproject.services;

import com.generatorproject.model.Contract;
import com.generatorproject.model.ContractEvent;
import com.generatorproject.model.Users;

import java.io.InputStream;
import java.sql.Date;
import java.util.List;

public interface IContractServices {
    Long saveContract(Contract contract);

    void updateContract(Contract contract);

    Contract findContractById(Long id);

    Contract findContractDetail(Long id);

    List<Contract> searchAndFilterContracts(String keyword, String status);

    List<Contract> findAllContracts();

    Long importContractFromDocx(InputStream fileContent, Users manager) throws Exception;

    void deleteContract(Long id);

    boolean terminateContract(Long contractId,
            String reasonCode,
            String terminatedReason,
            String decisionDoc,
            String note,
            Long actorId,
            String meta);

    List<Contract> getContractByCustomerId(int id);

    ContractEvent findLatestTerminatedEvent(Long contractId);

    List<ContractEvent> findEventsByContractId(Long contractId);

    int countByStatus(String status);

    int countExpiringSoon(int days);

    List<Contract> findRecent(int limit);

    Long assignSerialToContract(Long contractId,
            String serialNumber,
            Long modelId,
            Date purchaseDate,
            Integer manufactureYear,
            String currentLocation) throws Exception;

    void updateContractFilePath(Long contractId, String filePath);
}
