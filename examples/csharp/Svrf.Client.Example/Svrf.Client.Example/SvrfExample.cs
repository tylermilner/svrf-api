using System;
using System.Linq;
using SVRF.Client.Api;
using SVRF.Client.Model;

namespace SVRF.Client.Example
{
    class SvrfExample
    {
        static void Main()
        {
            var authApi = new AuthenticateApi();
            var mediaApi = new MediaApi();
            var body = new Body("your api key");

            try
            {
                // Authenticate application
                var authResult = authApi.Authenticate(body);
                Console.WriteLine(authResult.Token);
                mediaApi.Configuration.ApiKey["x-app-token"] = authResult.Token;

                var searchResult = mediaApi.Search("minsk");
                Console.WriteLine(searchResult.Media.FirstOrDefault()?.Title);

                var trendingResult = mediaApi.GetTrending();
                Console.WriteLine(trendingResult.Media.FirstOrDefault()?.Title);

                var idResult = mediaApi.GetById("1337");
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
