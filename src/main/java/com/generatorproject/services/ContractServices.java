package com.generatorproject.services;

import com.generatorproject.dao.ContractDAO;
import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;

import java.io.InputStream;
import java.util.List;

public class ContractServices implements IContractServices {
    private ContractDAO contractDAO;

    public ContractServices() {
        contractDAO = new ContractDAO();
    }

    @Override
    public Long saveContract(Contract contract) {
        if (contractDAO.isContractNumberExists(contract.getContractNumber())) {
            throw new RuntimeException("Số hợp đồng " + contract.getContractNumber() + " đã tồn tại!");
        }
        return contractDAO.save(contract);
    }

    @Override
    public void updateContract(Contract contract) {
        contractDAO.update(contract);
    }

    @Override
    public Contract findContractById(Long id) {
        return contractDAO.findById(id);
    }

    @Override
    public Contract findContractDetail(Long id) {
        return contractDAO.findByIdWithDetails(id);
    }

    @Override
    public List<Contract> searchAndFilterContracts(String keyword, String status) {
        return contractDAO.searchAndFilter(keyword, status);
    }

    @Override
    public List<Contract> findAllContracts() {
        return contractDAO.findAll();
    }

    @Override
    public Long importContractFromDocx(InputStream fileContent, Users manager) throws Exception {
        return contractDAO.importContractFromDocx(fileContent, manager);
    }

    @Override
    public void deleteContract(Long id) {
        contractDAO.delete(id);
    }

    @Override
    public List<Contract> getContractByCustomerId(int id) {
        return contractDAO.getContractByCustomerId(id);
    }

    @Override
    public int countByStatus(String status) {
        return contractDAO.countByStatus(status);
    }

    @Override
    public int countExpiringSoon(int days) {
        return contractDAO.countExpiringSoon(days);
    }

    @Override
    public List<Contract> findRecent(int limit) {
        return contractDAO.findRecent(limit);
    }
}
