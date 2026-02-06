package com.generatorproject.services;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;

import java.io.InputStream;
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

    List<Contract> getContractByCustomerId(int id);

    int countByStatus(String status);

    int countExpiringSoon(int days);

    List<Contract> findRecent(int limit);
}
