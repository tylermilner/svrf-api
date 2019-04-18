const Svrf = require('svrf-client');

// Replace this String with your Svrf API Key
const apiKey = 'XXXXXXXXXXXXXX';
const svrf = new Svrf(apiKey);

let nextPageNum = 0;

function trending () {
  // Only fetch 1 image per request. Set nextPage if available
  const options = {
    pageNum: nextPageNum,
    size: 1,
    type: Svrf.enums.mediaType.PHOTO,
  };

  return svrf.media.getTrending(options)
    .then((res) => {
      if (!res || !res.media.length) {
        return Promise.reject(new Error('No media returned'));
      }

      nextPageNum = res.nextPageNum;
      const {images} = res.media[0].files;

      // Use a 4096px wide image, otherwise try for a smaller image
      return images['4096'] || images['1080'];
    })
    .catch((err) => console.error(err));
}

module.exports = {
  trending,
};
