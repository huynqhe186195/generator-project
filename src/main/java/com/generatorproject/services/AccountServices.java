package com.generatorproject.services;

import com.generatorproject.dao.AccountDao;

public class AccountServices implements IAccountServices {
    private final AccountDao accountDao;
    public AccountServices() {
        accountDao = new AccountDao();
    }
    @Override
    public boolean changePassword(int userId, String newPassword) {
        return accountDao.changePassword(userId, newPassword);
    }
}
