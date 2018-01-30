/**
 * @Business: Queueable Class to make the Details TMDB call out
 * @Date: 2018-01-21
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2018-01-21     Initial Development
*/
public class TMDBDetailsRequest implements Queueable, Database.AllowsCallouts {
    
    private Set<Id> movieIds;
    
    public TMDBDetailsRequest(Set<Id> movieIdsSet){
    	this.movieIds = movieIdsSet;
    }
    
    public void execute(QueueableContext context) {
        
        List<Movie__c> movies = [Select Id, TMDB_ID__c From Movie__c Where Id IN: movieIds];
        List<Movie__c> newInfo = New List<Movie__c>();
        Set<Id> movieIdsSet = new Set<Id>();
        
        //Urls for Posters and Backdrops
        String poster = 'https://image.tmdb.org/t/p/w342';
        String backdrop = 'https://image.tmdb.org/t/p/original';
        
        for(Movie__c m : movies){

			String searchURL = 'https://api.themoviedb.org/3/movie/' +m.TMDB_ID__c + '?api_key=' + 
								System.Label.TMDB_API_Key + '&include_adult=false';

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(searchURL);
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug(response.getBody());

			if (response.getStatusCode() == 200) {
				// Send the response through the custom parse class to parse the data
				MovieInfoParse movie = MovieInfoParse.parse(response.getBody());
				
				//Get the Genres of the movie, if there are none then insert TBD
				Set<String> genresSet = new Set<String>();
				if(!movie.Genres.isEmpty()){
					for(MovieInfoParse.Genres g : movie.Genres){
						genresSet.add(g.name);
					}
					String genres = String.join(new List<String>(genresSet), ';');
            		m.Genres__c = genres;
				} else {
					m.Genres__c = 'TBD';
				}
				
				//Get the first production country of the Movie
				for(MovieInfoParse.Production_countries pc : movie.production_countries){
					m.Production_Country__c = pc.iso_3166_1;
					break;
				}
				
				//If the movie belongs to a collection insert the name and image urls
				if(movie.Belongs_to_collection != null){
            		m.Collection_Name__c = movie.Belongs_to_collection.name;
            		m.Collection_Poster__c = poster + movie.Belongs_to_collection.poster_path;
            		m.Collection_Backdrop__c = backdrop + movie.Belongs_to_collection.backdrop_path;
            	}

				//Insert the movie info that's received from the callout
            	m.Name = movie.title;
            	m.Poster_Link__c = poster + movie.poster_path;
            	m.Backdrop__c = backdrop + movie.backdrop_path;
            	m.Original_Language__c = movie.original_language;
            	m.Tagline__c = movie.tagline;
            	m.Overview__c = movie.overview;
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