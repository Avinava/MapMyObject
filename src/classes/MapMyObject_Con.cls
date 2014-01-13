global class MapMyObject_Con {
    public MapMyObject_Config__c config{get;set;}
    public sObject sobj{get;set;}
    public double Latitude{get;set;}
    public double Longitude{get;set;}
    public String address{get;set;}
    public Boolean isSuccess{get; private set;}
    public Boolean isConfigurationError{get; private set;}
    public String errorMessage{get; private set;}
    private String configurationName;
    
    public void setConfigurationName(String configurationName){
        this.configurationName = configurationName;
        init();
    } 
    
    public String getConfigurationName(){
        return configurationName;
    }
    
    public void init(){
        config = MapMyObject_Config__c.getValues(configurationName);
        sobj = createObject(config.Sobject_API__c);
        isSuccess = false;
    }
    
    @RemoteAction @Readonly
    global static List<MapDataWrapper> getObjectData(String configName){
        
        String whereClause;
        Set<String> additionalFields;
        List<MapDataWrapper> MapDataWrappers = new List<MapDataWrapper>();
        MapMyObject_Config__c config = MapMyObject_Config__c.getValues(configName);
        
        
        if(config.Latitude_Field_API__c  != NULL && config.Longitude_Field_API__c!= NULL){
            whereClause = config.Latitude_Field_API__c +' != NULL AND '+config.Longitude_Field_API__c + '!= NULL';
            additionalFields = new Set<String>{'Id',config.Longitude_Field_API__c,config.Latitude_Field_API__c};
        }
        String queryStr = CommonUtil.generateQueryFromFieldSet(config.Sobject_API__c,config.FieldSet_Name__c,additionalFields,whereClause);
        for(Sobject sobj: Database.query(queryStr)){
            Double lat,lang;
            if(config.Latitude_Field_API__c  != NULL && config.Longitude_Field_API__c!= NULL){
                lat = (Double)sobj.get(config.Latitude_Field_API__c);
                lang = (Double)sobj.get(config.Longitude_Field_API__c);
            }
            MapDataWrappers.add(new MapDataWrapper(sobj,lat,lang));
        }
        
        return MapDataWrappers;
    }
    
    global class MapDataWrapper{
        public Sobject sobj;
        public Double lat;
        public Double lang;
        
        public MapDataWrapper(Sobject sobj,Double lat,Double lang){
            this.sobj = sobj;
            this.lat = lat;
            this.lang = lang;
        }
    }
    
    public void save(){
        try{
            if(config.Latitude_Field_API__c != NULL){
                sobj.put(config.Latitude_Field_API__c,Latitude);
            }
            
            if(config.Longitude_Field_API__c != NULL){
                sobj.put(config.Longitude_Field_API__c,Longitude);
            }
            
            if(config.Address_Field_API__c != NULL){
                sobj.put(config.Address_Field_API__c,address);
            }
            
            String Idstr = String.valueOf(sobj.get('Id'));
            
            if(config.isCreate_Allowed__c && (Idstr == NULL || Idstr == '')){
                sobj.Id = NULL;
                insert sobj;
            }
            else{
                update sobj;
            }
            isSuccess = true;
            sobj = createObject(config.Sobject_API__c);
        }
        catch(Exception ex){
            Apexpages.addMessages(ex);
        }
    }
    
    public List<FieldSetMember> getNewFields(){
        return getFieldsFromFieldset(config.FieldSet_Name__c);
    }
    
    
    private List<FieldSetMember> getFieldsFromFieldset(String fieldSetName){
        List<FieldSetMember> fsms;
        try{
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectType = gd.get(config.Sobject_API__c);
            Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
            Map<String, Schema.FieldSet> FsMap = describeSObjectResult.fieldSets.getMap();
            Schema.FieldSet fieldSet = FsMap.get(fieldSetName);
            fsms = fieldSet.getFields();
        }
        catch(Exception ex){
            isConfigurationError = true;
            errorMessage = 'Error in configuration : Please check your configuration.';
                                
            System.debug('Error:'+ex);
            
        }
        return fsms;
    }
    
     private static sObject createObject(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        return targetType.newSObject(); 
    }
}