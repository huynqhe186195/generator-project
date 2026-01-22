package com.generatorproject.validation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.generatorproject.dao.DbContext;
import com.generatorproject.dao.GenericDAO;

public class UserValidate extends GenericValidation {
    public boolean checkEmailExist(String email) {
        return isValueExist("users", "email", email);
    }

    public boolean checkEmailExistForUpdate(String email, int userId) {
        return isValueExistExceptId("users", "email", email, userId);
    }

    public boolean checkPhoneExist(String phone) {
        return isValueExist("users", "phone", phone);
    }

    public boolean checkPhoneFormat(String phone) {
        if (phone == null || phone.isEmpty()) return false;
        return phone.matches("^0\\d{9}$");
    }

    public boolean checkPhoneExistForUpdate(String phone, int idToExclude) {
        return isValueExistExceptId("users", "phone", phone, idToExclude);
    }
}
