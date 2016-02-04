public with sharing class Configuration {

    public List<SelectOption> getCaseStatus()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult caseStatus=Case.status.getDescribe();
        List<Schema.PicklistEntry> ple = caseStatus.getPicklistValues();
        for(Schema.PicklistEntry pl:ple)
        {
            options.add(new SelectOption(pl.getLabel(), pl.getValue()));
        }
        return options;
    
    }
    public List<SelectOption> getLeadStatus()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult leadStatus=Lead.status.getDescribe();
        List<Schema.PicklistEntry> ple = leadStatus.getPicklistValues();
        for(Schema.PicklistEntry pl:ple)
        {
            options.add(new SelectOption(pl.getLabel(), pl.getValue()));
        }
        return options;
    
    }
}