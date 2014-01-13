@isTest
private class MapMyObject_PostInstall_Test{
    static testMethod void testInstallScript() {
        Test.startTest();
            MapMyObject_PostInstall postinstall = new MapMyObject_PostInstall();
            Test.testInstall(postinstall, null);
            Test.testInstall(postinstall, new Version(1,0), true);
        Test.stopTest();
    }
}