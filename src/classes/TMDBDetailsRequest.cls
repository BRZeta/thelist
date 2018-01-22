/**
 * @Business: Queueable Class to make the Details TMDB call out
 * @Date: 2018-01-21
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2018-01-21     Initial Development
*/
public class TMDBDetailsRequest implements Queueable, Database.AllowsCallouts {
    
    private Set<Id> movieIds;
    
    public TMDBDetailsRequest(Set<Id> queueableMovieSet){
    	this.movieIds = queueableMovieSet;
    }
    
    public void execute(QueueableContext context) {
        
        List<Movie__c> movies = [Select Id, TMDB_ID__c From Movie__c Where Id IN: movieIds];
        List<Movie__c> newInfo = New List<Movie__c>();
        Set<Id> movieIdsSet = new Set<Id>();
        
        for(Movie__c m : movies){

    		String startURL = 'https://image.tmdb.org/t/p/w300';
			String searchURL = 'https://api.themoviedb.org/3/movie/' +m.TMDB_ID__c + '?api_key=' + 
								System.Label.TMDB_API_Key + '&include_adult=false';

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(searchURL);
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug(response.getBody());

			if (response.getStatusCode() == 200) {
				// Send the response to the custom parse class to parse the data
				MovieInfoParse movie = MovieInfoParse.parse(response.getBody());
				
				Set<String> genresSet = new Set<String>();
				for(MovieInfoParse.Genres g : movie.Genres){
					genresSet.add(g.name);
				}
				String genres = String.join(new List<String>(genresSet), ';');

            	m.Name = movie.title;
            	m.Genres__c = genres;
            	m.Poster_Link__c = startURL + movie.poster_path;
            	m.Release_Date__c = movie.release_date;
            	m.Get_Details_Callout_Made__c = True;
            	newInfo.add(m);
            	movieIdsSet.add(m.Id);
			}
    	}

    	if(!newInfo.isEmpty()){
    		update newInfo;
    	}
    	
    	System.enqueueJob(new TMDBKeywordsRequest(movieIdsSet));
    }
}