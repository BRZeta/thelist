/**
 * @Business: Queueable Class to make the Details TMDB call out
 * @Date: 2018-01-21
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2018-01-21     Initial Development
*/
public class TMDBReleaseDatesRequest implements Queueable, Database.AllowsCallouts {
    
    private Set<Id> movieIds;
    
    public TMDBReleaseDatesRequest(Set<Id> queueableMovieSet){
    	this.movieIds = queueableMovieSet;
    }
    
    public void execute(QueueableContext context) {
        
        List<Movie__c> movies = [Select Id, TMDB_ID__c From Movie__c Where Id IN: movieIds];
        List<Movie__c> newInfo = New List<Movie__c>();
        Set<Id> movieIdsSet = new Set<Id>();
        
        //Urls for Posters and Backdrops
        String poster = 'https://image.tmdb.org/t/p/w342';
        String backdrop = 'https://image.tmdb.org/t/p/original';
        String collectionPoster = 'https://image.tmdb.org/t/p/w342';
        
        for(Movie__c m : movies){

			String searchURL = 'https://api.themoviedb.org/3/movie/' +m.TMDB_ID__c + '/release_dates?api_key=' + 
								System.Label.TMDB_API_Key;

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(searchURL);
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug(response.getBody());

			if (response.getStatusCode() == 200) {
				// Send the response to the custom parse class to parse the data
				MovieDateParseWrapper.MovieDateParse movie = MovieDateParseWrapper.parse(response.getBody());
				
				//Get the release date of the movie. If only 1 date, then insert that one, if more than one insert US
				//If the movie was not released in the US and has more than one get the earlist release date
				list<date> AllDates = new list<date>();
				for(MovieDateParseWrapper.results d : movie.results){
					
					system.debug('value of d: '+ d);
					
					for(MovieDateParseWrapper.Release_dates re: d.release_dates){
						if(movie.results.size() == 1){
							m.Release_Date__c = date.valueOf(re.release_date);
                            break;
						} else if (movie.results.size() > 1){
							if(d.iso_3166_1 == 'US'){
								m.Release_Date__c = date.valueOf(re.release_date);
	                            break;
							} 
						} else {
							AllDates.add(date.valueOf(re.release_date));
                            AllDates.sort();
                            m.Release_Date__c = AllDates[0];
						}
					}
				}
				m.Get_Release_Dates_Callout_Made__c = True;
            	newInfo.add(m);
            	movieIdsSet.add(m.Id);
			}
    	}

    	if(!newInfo.isEmpty()){
    		update newInfo;
    	}
    	System.enqueueJob(new TMDBDetailsRequest(movieIdsSet));
    	
    }
}