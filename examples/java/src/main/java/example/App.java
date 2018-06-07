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
        
        Body body = new Body();
        body.apiKey("your api key");
        
        try {
            AuthResponse result = apiInstance.appAuthenticatePost(body);
            System.out.println(result);
            ApiClient client = new ApiClient();
            client.setApiKey(result.getToken());
            mediaApi.setApiClient(client);

            SingleMediaResponse m = mediaApi.vrIdGet("82989");
            System.out.println(m);

            TrendingResponse t = mediaApi.vrTrendingGet(5, null);
            System.out.println(t);

            SearchMediaResponse s = mediaApi.vrSearchGet("svrf", null, null, null, null);
            System.out.println(s);
        } catch (ApiException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}