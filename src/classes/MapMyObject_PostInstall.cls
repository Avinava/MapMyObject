global class MapMyObject_PostInstall implements InstallHandler {
    global void onInstall(InstallContext context) {
        if(context.previousVersion() == null) {
               MapMyObject_Config__c config = new MapMyObject_Config__c(
                                                                            Name = 'Account',
                                                                            FieldSet_Name__c = 'MapMyObject__MapMyObject',
                                                                            SObject_API__c = 'Account',
                                                                            Address_Field_API__c = 'ShippingStreet',
                                                                            Latitude_Field_API__c = 'Shipping_Address__Latitude__s',
                                                                            Longitude_Field_API__c = 'Shipping_Address__Longitude__s'
                                                                        );
              insert config;
              
              User u = [Select Id, Email from User where Id =:context.installerID()];   
              String toAddress= u.Email;
              String[] toAddresses = new String[]{toAddress};
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setToAddresses(toAddresses);
              mail.setReplyTo('avi@cloudCaliber.com');
              mail.setSenderDisplayName('MapMyObject Support');
              mail.setSubject('MapMyObject install successful');
              String emailBody = 'Hi,<br/>You have just installed MapMyObject app. This is a highly capable mapping app and can work with almost objects. Please feel free to ask any questions or about any development/customization services that we offer.';
              String docsLinks = 'There are few steps involved after you install this app to make it working. Have a look at this tutorial(http://mapmyobject-developer-edition.ap1.force.com/MapMyObjectIntro) for further details about configuring the app.';
              String signature = 'Thanks,<br/>Avi<br/>avi@cloudCaliber.com';
              mail.setHtmlBody(emailBody+'<br/>'+docsLinks + '<br/><br/>' + signature);
              Messaging.sendEmail(new Messaging.Email[] { mail });
        }
        else if(context.previousVersion().compareTo(new Version(1,0)) == 0) {
            //for future use
        }
          
        if(context.isUpgrade()) {
            //for future use
        }
        if(context.isPush()) {
            //for future use
        }
    }
}