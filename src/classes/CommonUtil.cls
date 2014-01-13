public class CommonUtil {
    
    public static String generateCSVFromFieldsets(String sObjectName,Set<String> fieldSets,Set<String> additionalFields){
        String fieldcsv = 'Id';
        Set<String> fields = new Set<String>{'Id'};
        //describe the provided sObject
        Schema.DescribeSObjectResult res=Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        //get the fields set map
        Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap();
        
        if(additionalFields!=null)
        for( String fs : additionalFields ) {                   
           //add only unique fields
           if(!fields.contains(fs)){
               //maintain a set of fields so that only unique fields are added in query
               fields.add(fs);
               fieldcsv = fieldcsv+','+fs;
           }        
        }
        //iterate through provided fieldsets and generate query       
        for(String fieldSetName : fieldSets){
            Schema.FieldSet fs = fieldSetMap.get(fieldSetName);
            for( Schema.FieldSetMember fsm : fs.getFields() ) {                   
               //add only unique fields
               if(!fields.contains(fsm.getFieldPath())){
                   //maintain a set of fields so that only unique fields are added in query
                   fields.add(fsm.getFieldPath());
                   fieldcsv = fieldcsv+','+fsm.getFieldPath();
               }        
            }
        }
        
        return fieldcsv;
    }
    
    public static String generateQueryFromFieldSet(String sObjectName,String fieldSet,Set<String> additionalFields,String whereClause){
        return generateQueryFromFieldSets(sObjectName,new Set<String>{fieldSet},additionalFields,whereClause);
    }
    
    public static String generateQueryFromFieldSets(String sObjectName,Set<String> fieldSets,Set<String> additionalFields,String whereClause){
        Set<String> fields = new Set<String>{'Id'};
        String query='SELECT '+generateCSVFromFieldsets(sObjectName,fieldSets,additionalFields);
        
        query = (whereClause == '' || whereClause ==null) 
                        ? (query + ' FROM '+sObjectName) 
                        : (query + ' FROM '+sObjectName + ' WHERE ' + whereClause);
        
        return query;
    }
    
    public static List<String> getPicklistValues(Schema.DescribeFieldResult fieldResult){
       List<String> options = new List<String>();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
       for( Schema.PicklistEntry f : ple){
          options.add(f.getLabel());
       }       
       return options;
    }
    
    
}