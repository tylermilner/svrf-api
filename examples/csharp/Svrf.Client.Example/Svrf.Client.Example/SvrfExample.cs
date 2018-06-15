using System;
using System.Linq;
using Svrf.Client.Api;
using Svrf.Client.Model;

namespace Svrf.Client.Example
{
    class SvrfExample
    {
        static void Main()
        {
            var authApi = new AuthenticateApi();
            var mediaApi = new MediaApi();
            var body = new Body("your key");

            try
            {
                // Authenticate application
                var authResult = authApi.AppAuthenticatePost(body);
                Console.WriteLine(authResult.Token);
                mediaApi.Configuration.ApiKey["x-app-token"] = authResult.Token;

                var searchResult = mediaApi.VrSearchGet("minsk");
                Console.WriteLine(searchResult.Media.FirstOrDefault()?.Title);

                var trendingResult = mediaApi.VrTrendingGet();
                Console.WriteLine(trendingResult.Media.FirstOrDefault()?.Title);

                var idResult = mediaApi.VrIdGet("1337");
                Console.WriteLine(idResult.Media?.Title);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            Console.ReadKey();
        }
    }
}
