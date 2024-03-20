function Component()
{
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
}

Component.prototype.createOperations = function()
{
    component.createOperations();

    if (systemInfo.productType === "windows") {
        component.addOperation(     "Execute",
                                    "msiexec",
                                    "/i",
                                    "@TargetDir@\\driver.msi",
                                    "/passive",
                                    "/norestart"    );

        component.addOperation(     "CreateShortcut",
                                    "@TargetDir@/AGCS.exe",
                                    "@StartMenuDir@/AGCS.lnk",
                                    "workingDirectory=@TargetDir@"      );

        component.addOperation(     "CreateShortcut",
                                    "@TargetDir@/AGCS.exe",
                                    "@DesktopDir@/AGCS.lnk",
                                    "workingDirectory=@TargetDir@"      );
    }
}
