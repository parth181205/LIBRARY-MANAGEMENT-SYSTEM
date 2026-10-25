package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class SystemSetting implements Serializable {
    private static final long serialVersionUID = 1L;

    private String settingKey;
    private String settingValue;
    private String settingType;
    private String description;
    private Timestamp updatedAt;

    public SystemSetting() {}

    public SystemSetting(String settingKey, String settingValue, String settingType, String description) {
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.settingType = settingType;
        this.description = description;
    }

    public String getSettingKey() { return settingKey; }
    public void setSettingKey(String settingKey) { this.settingKey = settingKey; }

    public String getSettingValue() { return settingValue; }
    public void setSettingValue(String settingValue) { this.settingValue = settingValue; }

    public String getSettingType() { return settingType; }
    public void setSettingType(String settingType) { this.settingType = settingType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
