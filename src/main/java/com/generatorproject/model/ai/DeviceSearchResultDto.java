package com.generatorproject.model.ai;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DeviceSearchResultDto {
    private Long productId;
    private Long modelId;
    private String modelName;
    private String brandName;
    private String serialNumber;
    private String currentLocation;
    private String status;
    private String detailUrl;
    private String deviceType;
    private String deviceTypeLabel;
    private String description;

}