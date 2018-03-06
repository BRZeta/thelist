public class SingleMovieController {
    
    //public Movie__c movie {get;set;}
    public string TMDBId {get;set;}
    
    public SingleMovieController(){

        TMDBId = ApexPages.currentPage().getParameters().get('TMDB');
    }
    
    public Movie__c getMovie() {
        
        Movie__c movie;
        
        try {
            movie = [Select Id, Name, TMDB_ID__c, Backdrop__c From Movie__c Where TMDB_ID__c =: TMDBId];
            
        } catch(Exception ex) {
            logException('Exception in getNewMovies', ex);
        }
        return movie;
        
    }
    
    private void logException(String errorTitle, Exception ex) {
        String placholderMsg = '\n {0} \n Error: {1} \n Stack Trace: {2}';
        String[] fillers = new String[] {errorTitle, ex.getMessage(), ex.getStackTraceString()};
        System.debug(String.format(placholderMsg, fillers));
    }
}