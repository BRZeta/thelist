/**
 * @Business: Invocable Method to be used from Visual Workflow Button
 * @Date: 2018-01-18
 * @Author: JOSE ALCALA
 * ModifiedDate   Description
 * 2018-01-18     Initial Development
*/
public class GetMovieInformation {
	
	public class MovieList {
        public KeyWordItem[] keywords;
    }
    public class KeyWordItem {
        public String CONTAINER, id, name;
    }
	
    @InvocableMethod
    public static void updateMovieInformation(List<Id> movieIds){
    	
    	List<Movie__c> movies = [Select Id, Name, TMDB_ID__c, Release_Date__c From Movie__c Where Id IN: movieIds];
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