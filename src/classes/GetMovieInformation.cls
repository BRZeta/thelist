/**
 * @Business: Invocable Method to be used from Visual Workflow Button to Get TMDB ID
 * @Date: 2018-01-18
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2018-01-18     Initial Development
*/
public class GetMovieInformation {
	
	public class MovieList {
        public MovieItem[] results;
    }
    public class MovieItem {
        public String CONTAINER, id, poster_path, title;
        public Date release_date;
    }
	
    @InvocableMethod
    public static void updateMovieInformation(List<Id> movieIds){
    	
    	List<Movie__c> movies = [Select Id, Name, TMDB_ID__c, Release_Date__c From Movie__c Where Id IN: movieIds];
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
}