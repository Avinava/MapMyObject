@isTest
private class MapMyObject_Con_Test{
    static testMethod void testMapMyObject(){
        MapMyObject_Config__c config = new MapMyObject_Config__c(
                                                                    Name = 'Account',
                                                                    FieldSet_Name__c = 'MapMyObject__MapMyObject',
                                                                    SObject_API__c = 'Account',
                                                                    Address_Field_API__c = 'BillingStreet',
                                                                    Latitude_Field_API__c = 'Shipping_Address__Latitude__s',
                                                                    Longitude_Field_API__c = 'Shipping_Address__Longitude__s'
                                                                );
                                                                
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 10; i ++){
            accList.add(new Account(Name='Test'+i,Shipping_Address__Latitude__s =0,Shipping_Address__Longitude__s = 0));
        }
        insert accList;
        
        insert config;
        MapMyObject_Con controller = new MapMyObject_Con();
        controller.setConfigurationName(config.Name);
        System.assertEquals(accList.size(),MapMyObject_Con.getObjectData(config.Name).size());
        controller.sobj = accList[0];
        System.assertNotEquals(NULL,controller.getNewFields());
        controller.save();
        controller.getConfigurationName();
        
        //generate error
        config.FieldSet_Name__c = 'TestErrorxxx';
        update config;
        controller.setConfigurationName(config.Name);
        System.assertEquals(NULL,controller.getNewFields());
        //generate error in save
        config.Latitude_Field_API__c = 'TestAPIName';
        update config;
        controller.setConfigurationName(config.Name);
        controller.save();
        
    }
}