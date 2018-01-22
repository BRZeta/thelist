/**
 * @Business: Standard Trigger Handler
 * @Date: 2017-12-20
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2017-12-20     Initial Development
 * 2017-27-20     Created methods to call out to TMDB API to get movie information
 * 2018-01-18     Updated method to add genres
*/
public class MovieTriggerHandler {
    
	public MovieTriggerHandler() {
        
    }
    public Boolean IsAfter  { get; set; }
    public Boolean IsBefore { get; set; }
    public Boolean IsInsert { get; set; }
    public Boolean IsUpdate { get; set; }
    public Boolean IsDelete { get; set; }
    public Boolean IsUnDelete { get; set; }
    public map<id,Movie__c> oldMap {get; set;}
    public map<id,Movie__c> newMap {get; set;}
    public List<Movie__c> NewM { get; set; }
    public List<Movie__c> OldM { get; set; }
    
    public void process() {

    	Set<Id> movieSearchSet = new Set<Id>();
    	Set<Id> movieIdSet = new Set<Id>();
    	Set<Id> queueableMovieSet = new Set<Id>();

    	if(IsAfter){
    		if(IsInsert){
    			for(Movie__c m : NewM){
    				if(m.Release_Date__c != null){
    					movieSearchSet.add(m.Id);
    				} else if(m.TMDB_ID__c != null){
    					movieIdSet.add(m.Id);
    				}
    			}
    		}
    		if(IsUpdate){
    			for(Movie__c m: NewM){
    				if(m.TMDB_ID__c != null && m.TMDB_ID__c != oldMap.get(m.Id).TMDB_ID__c){
    					queueableMovieSet.add(m.Id);
    				}
    			}
    		}
    	}

    	if(!movieSearchSet.isEmpty()){
    		SearchMovieInformation(movieSearchSet);
    	}

    	if(!movieIdSet.isEmpty()){
    		MovieByIdInformation(movieIdSet);
    		SearchKeyWords(movieIdSet);
    	}
    	
    	if(!queueableMovieSet.isEmpty()){
    		System.enqueueJob(new TMDBDetailsRequest(queueableMovieSet));
    	}
    }
    public class MovieList {
        public MovieItem[] results;
        public KeyWordItem[] keywords;
    }
    public class MovieItem {
        public String CONTAINER, id, poster_path, title;
        public Date release_date;
    }
    public class KeyWordItem {
        public String CONTAINER, id, name;
    }

    @future(callout = true)
    public static void SearchMovieInformation (Set<Id> movieSearchSet){
    	List<Movie__c> movies = [Select Id, Name, TMDB_ID__c, Release_Date__c From Movie__c Where Id IN: movieSearchSet];
    	List<Movie__c> newInfo = new List<Movie__c>();

    	for(Movie__c m : movies){

    		String startURL = 'https://image.tmdb.org/t/p/w300';
			String movieName = EncodingUtil.urlEncode( m.Name, 'UTF-8');
			String searchURL = 'https://api.themoviedb.org/3/search/movie?api_key=' + System.Label.TMDB_API_Key +
							   '&page=1&include_adult=false&query=' + movieName;

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(searchURL);
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug(response.getBody());

			if (response.getStatusCode() == 200) {
				// Parse the data according to the results class
		        MovieList data = (MovieList)JSON.deserialize(response.getBody(), MovieList.class);
		        system.debug('data returned: '+ data);
		        // Iterate over the data
		        for(MovieItem mi : data.results) {
		            if(mi.release_date.year() == m.Release_Date__c.year()){
		            	m.TMDB_ID__c = mi.id;
		            	m.Get_Id_Callout_Made__c = True;
		            	//m.Name = mi.title;
		            	//m.Poster_Link__c = startURL + mi.poster_path;
		            	//m.Release_Date__c = mi.release_date;
		            	newInfo.add(m);
		            	break;
		            }
		        }
			}
    	}

    	if(!newInfo.isEmpty()){
    		update newInfo;
    	}
    }

    @future(callout = true)
    public static void MovieByIdInformation (Set<Id> movieIdSet){
    	List<Movie__c> movies = [Select Id, Name, TMDB_ID__c From Movie__c Where Id IN: movieIdSet];
    	List<Movie__c> newInfo = new List<Movie__c>();

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
            	newInfo.add(m);
			}
    	}

    	if(!newInfo.isEmpty()){
    		update newInfo;
    	}
    }
    
    @future(callout = true)
    public static void SearchKeyWords (Set<Id> keywordSearchSet){
    	List<Movie__c> movies = [Select Id, Name, TMDB_ID__c, Release_Date__c From Movie__c Where Id IN: keywordSearchSet];
    	List<Movie__c> newInfo = new List<Movie__c>();

    	for(Movie__c m : movies){

			String searchURL = 'https://api.themoviedb.org/3/movie/' +m.TMDB_ID__c + '/keywords?api_key=' + 
								System.Label.TMDB_API_Key;

			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(searchURL);
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug(response.getBody());

			if (response.getStatusCode() == 200) {
				// Parse the data according to the results class
		        MovieList data = (MovieList)JSON.deserialize(response.getBody(), MovieList.class);
		        system.debug('data returned: '+ data);
		        
		        Set<String> keyWordSet = new Set<String>();
		        for(KeyWordItem kw : data.keywords) {
		        	keyWordSet.add(kw.name);
		        }
		        String keyWords = String.join(new List<String>(keyWordSet), ',');
		        
		        if(keyWords != ''){
		        	m.Key_Words__c = keyWords;
		        	newInfo.add(m);
		        } else {
		        	m.Key_Words__c = 'TBD';
		        	newInfo.add(m);
		        }
			}
    	}

    	if(!newInfo.isEmpty()){
    		update newInfo;
    	}
    }
}