CREATE TABLE [tblGlobalSettings] ( 
[CreationDate] DATE, 
[ModifiedDate] DATE, 
[SettingCategory] VARCHAR(255), 
[SettingDescription] MEMO, 
[SettingId] COUNTER , 
[SettingName] VARCHAR(255), 
[SettingValue] MEMO, 
[ValidationRule] VARCHAR(255), 
[ValueType] VARCHAR(255), 
CONSTRAINT PrimaryKey PRIMARY KEY (SettingId) 
);