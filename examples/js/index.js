const SVRF = require('svrf-client');

const authApi = new SVRF.AuthenticateApi();
const mediaApi = new SVRF.MediaApi();

const body = new SVRF.Body();
body.apiKey = 'your api key';

authApi.appAuthenticatePost(body)
  .then(({token}) => mediaApi.apiClient.authentications.XAppToken.apiKey = token)
  .then(() => mediaApi.vrTrendingGet())
  .then((result) => console.log(result))
  .then(() => mediaApi.vrSearchGet('minsk'))
  .then((result) => console.log(result))
  .then(() => mediaApi.vrIdGet('1337'))
  .then((result) => console.log(result))
  .catch((err) => console.error(err));
