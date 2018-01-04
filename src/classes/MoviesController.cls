public class MoviesController {

    public String yearInstalled {get;set;}
    private Integer year = Date.Today().Year(); 
    public List<SelectOption> lstYear{get;set;}
    String section = 'All';
    public String boxOffice = Schema.sObjectType.Movie__c.getRecordTypeInfosByName().get('Box Office').getRecordTypeId();
    public String homeTheater = Schema.sObjectType.Movie__c.getRecordTypeInfosByName().get('Home Theater').getRecordTypeId();
	
    public MoviesController(){

        string year_s = ApexPages.currentPage().getParameters().get('year');
        lstYear = lstYearInstalled();
        doSearch(year_s);
    }


    public PageReference test() {
        return null;
    }
        
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Upcoming Movies','Upcoming Movies'));
        options.add(new SelectOption('Box Office','Box Office'));
        options.add(new SelectOption('Home Theater','Home Theater'));
        return options;
    }
        
    public String getSection() {
        return section;
    }
        
    public void setSection(String section) {
        this.section = section;
    }












    public void doSearch(String year_s){

        Integer n = String.isNotBlank(year_s) 
                  ? Integer.valueOf(year_s) 
                  : (String.isBlank(yearInstalled) ? 0 : Integer.valueof(yearInstalled));
    }

    //list of movies for the upcoming section
    public List<Movie__c> getnewMovies() {
        
        List<Movie__c> listNewMovies;
        
        try {
            listNewMovies = [SELECT Id, Name, Poster_Link__c, Rating__c, Release_Date__c, Anticipation__c,
                          	 Combined_Rating__c, Location__c, View_Date__c, RecordTypeId 
                             From Movie__c Where RecordTypeId =: boxOffice AND View_Date__c = null 
                             Order By Release_Date__c ASC];
            
        } catch(Exception ex) {
            logException('Exception in getNewMovies', ex);
        }
        return listNewMovies;
        
    }

    //list of movies for the box office and home sections
    public List<Movie__c> getMovies() {

        List<Movie__c> listMovies;

        try {
            listMovies = [SELECT Id, Name, Money_Rating__c, Price__c, View_Date__c, Poster_Link__c, Rating__c,
                          Combined_Rating__c, Location__c, RecordTypeId, Release_Date__c
                          From Movie__c Where View_Date__c != null Order By View_Date__c DESC];
        } catch(Exception ex) {
            logException('Exception in getMovies', ex);
        }
        return listMovies;
    }
    
    private void logException(String errorTitle, Exception ex) {
        String placholderMsg = '\n {0} \n Error: {1} \n Stack Trace: {2}';
        String[] fillers = new String[] {errorTitle, ex.getMessage(), ex.getStackTraceString()};
        System.debug(String.format(placholderMsg, fillers));
    }

    // get year viewed    
    public List<SelectOption> lstYearInstalled() {
        List<SelectOption> options = new List<SelectOption>();
        Integer i = year;
        
        options.add(new SelectOption('','- ALL -'));
        while ( i >= year-8){
            options.add(new SelectOption(i+'',i+''));
            i--;
        }
        if(!options.isEmpty()) yearInstalled = options.get(0).getValue();
        
        return options;
    }
}