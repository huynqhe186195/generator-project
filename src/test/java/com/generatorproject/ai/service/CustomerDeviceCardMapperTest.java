package com.generatorproject.ai.service;

import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;
import org.junit.Assert;
import org.junit.Test;

public class CustomerDeviceCardMapperTest {
    @Test
    public void mapsOwnedProductToOwnedCard() {
        Product product = Product.builder()
                .id(10)
                .modelId(99L)
                .modelName("Denyo DCA-150")
                .brandName("Denyo")
                .serialNumber("SN-001")
                .currentLocation("Bình Dương")
                .status("ACTIVE")
                .build();

        DeviceSearchResultDto dto = CustomerDeviceCardMapper.fromOwned(product, "/cms");

        Assert.assertEquals("OWNED", dto.getDeviceType());
        Assert.assertEquals("SN-001", dto.getSerialNumber());
        Assert.assertEquals("/cms/products/detail?id=99", dto.getDetailUrl());
    }

    @Test
    public void mapsPublicModelToPublicCard() {
        ProductModel model = new ProductModel.Builder()
                .setId(77)
                .setName("Cummins C220")
                .build();

        DeviceSearchResultDto dto = CustomerDeviceCardMapper.fromPublic(model, null, "/cms");

        Assert.assertEquals("PUBLIC", dto.getDeviceType());
        Assert.assertEquals("Cummins C220", dto.getModelName());
        Assert.assertEquals("/cms/products/detail?id=77", dto.getDetailUrl());
    }
}
