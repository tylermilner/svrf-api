package example;

import com.svrf.client.*;
import com.svrf.client.model.*;
import com.svrf.client.api.AuthenticateApi;
import com.svrf.client.api.MediaApi;

import java.io.File;
import java.util.*;

public class App {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();

        AuthenticateApi apiInstance = new AuthenticateApi();
        MediaApi mediaApi = new MediaApi();
        
        Body body = new Body()
            .apiKey("your api key");
        
        try {
            AuthResponse result = apiInstance.authenticate(body);
            System.out.println(result);
            ApiClient client = new ApiClient();
            client.setApiKey(result.getToken());
            mediaApi.setApiClient(client);

            SingleMediaResponse m = mediaApi.getById("82989");
            System.out.println(m.getMedia().getTitle());

            TrendingResponse t = mediaApi.getTrending(5, null);
            System.out.println(t.getMedia().get(0).getTitle());

            SearchMediaResponse s = mediaApi.search("svrf", null, null, null, null);
            System.out.println(s.getMedia().get(0).getTitle());
        } catch (ApiException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}