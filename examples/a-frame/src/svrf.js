const SVRF = require('svrf-client');

const defaultClient = SVRF.ApiClient.instance;
// Configure API key authorization: XAppToken
const XAppToken = defaultClient.authentications['XAppToken'];
const authApi = new SVRF.AuthenticateApi();
const mediaApi = new SVRF.MediaApi();
const apiKey = 'XXXXXXXXXXXXXX';

let token;
let nextPageCursor;

function authenticate() {
  if (token) {
    return Promise.resolve();
  }
  
  const body = new SVRF.Body(apiKey);

  return authApi.authenticate(body)
    .then((res) => {
      XAppToken.apiKey = res.token;
    });
}

function trending () {
  // Only fetch 1 image per request. Set nextPageCursor if available
  const options = Object.assign({size: 1}, nextPageCursor ? {nextPageCursor} : null);

  return authenticate()
    .then(() => mediaApi.getTrending(options))
    .then((res) => {
      if (!res || !res.media.length) {
        return Promise.reject(new Error('No media returned'));
      }

      nextPageCursor = res.nextPageCursor;
      const {images} = res.media[0].files;

      // Use 4096px image if available, otherwise try for smaller image
      return images['4096'] || images['1080'];
    })
    .catch((error) => {
      console.error(error);
    });
}

module.exports = {
  trending,
};
