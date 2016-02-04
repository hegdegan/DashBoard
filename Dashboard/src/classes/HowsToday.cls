public with sharing class HowsToday {
    
    Public List<AggregateResult> closedCountByOwner;
    //public List<AggregateResult> caseCountByStatus;
    //
    //Leads
     
    public String showSection;
    
    public String selectedValue{get;set;}
    
    public PageReference showSections()
    {
        //getshowSection();
        return Page.HowsToday;
    } 
    
    public String getshowSection()
    {
        if(selectedValue!='')
            showSection=selectedValue;
        else
            showSection='Cases';
        return showSection;
    }
    
    String queryDate='TODAY';
    Datetime d=DateTime.now().addDays(-1);
    
    public HowsToday()
    {
        
    }
    public Integer getCaseCreated()
    {
        Integer caseCreated=Database.countQuery('select count() from Case where createddate='+queryDate);
        return caseCreated;
    }
    public Integer getCasesClosed()
    {    
        Integer casesClosed=Database.countQuery('select count() from Case where closedDate='+queryDate+' and status=\'Closed\'');
        return casesClosed;
        
    }
    public Integer getCasesUpdated()
    {
        Integer casesUpdated=Database.countQuery('select count() from Case where lastmodifieddate='+queryDate+' and status!=\'New\' and status!=\'Closed\'');
        return casesUpdated;
    }
    public Integer getCasesNotUpdated()
    {
        Integer casesNotUpdated=Database.countQuery('select count() from Case where status=\'New\'');
        return casesNotUpdated;
    }
    public List<BarStatusData> getCasesByStatus()
    {
        List<AggregateResult> caseCountByStatus=[select Status status, count(id) total from case group by Status];
        
        List<BarStatusData> barStatusData= new List<BarStatusData>(); // should be a publicly available variable so either declare it at class level or provide a getter ;)
        for (AggregateResult ar: caseCountByStatus) {
            barStatusData.add(new BarStatusData(ar));
        }
        return barStatusData;
        
    }
    public List<BarPriorityData> getCasesByPriority()
    {
        List<AggregateResult> caseCountByStatus=[select Priority priority, count(id) total from case group by priority];
        
        List<BarPriorityData> barPriorityData= new List<BarPriorityData>(); // should be a publicly available variable so either declare it at class level or provide a getter ;)
        for (AggregateResult ar: caseCountByStatus) {
            BarPriorityData.add(new BarPriorityData(ar));
        }
        return barPriorityData;
        
    }
    
    public List<PieCaseClosed> getCaseClosedByOwner()
    {
        List<AggregateResult> caseClosedByOwner=[select Owner.name owner, count(id) total from case where status='Closed' group by owner.name ];
        
        List<PieCaseClosed> pieCaseClosedData= new List<PieCaseClosed>(); 
        for (AggregateResult ar: caseClosedByOwner) {
            pieCaseClosedData.add(new PieCaseClosed(ar));
        }
        return pieCaseClosedData;
        
    }
    
    
    public List<Wrapper> getClosedCountByOwner()
    {
        Integer count=0;
        String ownerName='';
        String currentOwnerName='';
        Integer newCount=0;
        Integer closedCount=0;
        closedCountByOwner=[select Owner.name owner, Status status, count(id) Total from case group by Owner.name, Status order by owner.name];
        List<Wrapper> wrappers = new List<Wrapper>();
        for (AggregateResult ar: closedCountByOwner) {
            if(ownerName=='')
            {
                
                ownerName=String.valueOf(ar.get('owner'));
                //system.debug('ownername================================>'+ownerName);
            }
            if(ownerName!=String.valueOf(ar.get('owner')))
            {
                wrappers.add(new Wrapper(ownerName,newCount,closedCount));
                ownerName=String.valueOf(ar.get('owner'));
                newCount=0;
                closedCount=0;
            }
            currentOwnerName=String.valueOf(ar.get('owner'));
            if(String.valueOf(ar.get('status'))=='New')
            {
                newCount=Integer.valueOf(ar.get('Total'));
                //system.debug('newCount================================>'+newCount);
            }
            
            if(String.valueOf(ar.get('status'))=='Closed')
                closedCount=Integer.valueOf(ar.get('Total'));
            
            
        }
        wrappers.add(new Wrapper(currentOwnerName,newCount,closedCount));
        return wrappers;
        
    }
    
    // Wrapper class
    public class PieWedgeData {
        
        public String name { get; set; }
        public Integer data { get; set; }
        
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }
    public class Wrapper{
        public Integer Total{get; set;}
        public String Owner{get; set;}
        public Integer newCount{get;set;}
        public Integer closedCount{get;set;}
        
        // Constructor
        public Wrapper(String ownerName,Integer newCount, Integer closedCount){
            //system.debug('inside wrapper======================================================>'+ownerName);
            this.owner=ownerName;
            this.newCount=newCount;
            this.closedCount=closedCount;
            
            
        }
    }
    
    public class BarStatusData{
        public Integer total{get; set;}
        public String status{get; set;}
        
        public BarStatusData(AggregateResult ar)
        {
            total= Integer.valueOf(ar.get('total'));
            status= String.valueOf(ar.get('status'));
        }
    }
    public class BarPriorityData{
        public Integer total{get; set;}
        public String priority{get; set;}
        
        public BarPriorityData(AggregateResult ar)
        {
            total= Integer.valueOf(ar.get('total'));
            priority= String.valueOf(ar.get('priority'));
        }
    }
    public class PieCaseClosed{
        public Integer total{get; set;}
        public String owner{get; set;}
        
        public PieCaseClosed(AggregateResult ar)
        {
            total= Integer.valueOf(ar.get('total'));
            owner= String.valueOf(ar.get('owner'));
        }
    }
    
    
    //Leads========================================
    public Integer getLeadsCreated()
    {
        Integer leadsCreated=Database.countQuery('select count() from Lead where createdDate='+queryDate);
        return LeadsCreated;
    }
    public Integer getLeadsConverted()
    {    
        Integer leadsConverted=Database.countQuery('select count() from Case where convertedDate='+queryDate+' and status=\'Closed - Converted\'');
        return leadsConverted;
        
    }
    public Integer getLeadsUpdated()
    {
        Integer leadsUpdated=Database.countQuery('select count() from Lead where lastmodifieddate='+queryDate+' and status!=\'New\' and status!=\'Closed - Not Converted\' and status!=\'Closed - Converted\'');
        return leadsUpdated;
    }
    public Integer getLeadsNotUpdated()
    {
        Integer leadsNotUpdated=Database.countQuery('select count() from Lead where status=\'Open - Not Contacted\'');
        return leadsNotUpdated;
    }
    
    public List<SelectOption> getSectionValue()
    {
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('Cases', 'Cases'));
        options.add(new SelectOption('Leads', 'Leads'));
        options.add(new SelectOption('Accounts', 'Accounts'));
        options.add(new SelectOption('Contacts', 'Contacts'));
        options.add(new SelectOption('Opportunities', 'Opportunities'));
        options.add(new SelectOption('Contracts', 'Contracts'));
        options.add(new SelectOption('Orders', 'Orders'));
        options.add(new SelectOption('Users', 'Users'));
        return options;
        
        
    }
    
    
}