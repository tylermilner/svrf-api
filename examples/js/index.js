const SVRF = require('svrf-client');

const authApi = new SVRF.AuthenticateApi();
const mediaApi = new SVRF.MediaApi();

const body = new SVRF.Body('your api key');

authApi.authenticate(body)
  .then(({token}) => mediaApi.apiClient.authentications.XAppToken.apiKey = token)
  .then(() => mediaApi.getTrending())
  .then((result) => console.log(result.media[0].title))
  .then(() => mediaApi.search('minsk'))
  .then((result) => console.log(result.media[0].title))
  .then(() => mediaApi.getById('1337'))
  .then((result) => console.log(result.media.title))
  .catch((err) => console.error(err));
