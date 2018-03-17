# Getting Started

SVRF's API allows you to supercharge your project or app with the first and largest search engine for immersive experiences. We make it dead simple for any developer to incorporate highly immersive experiences with all kinds of applications: virtual reality, augmented reality, mixed reality, mobile, and web.

The SVRF API is based on REST principles, allowing you to integrate it cross-platform. Our endpoints return responses in [JSON][]. We support [CORS][], allowing you to access immersive experiences indexed by SVRF on your web domain. We provide a variety of resolutions, projections, and file formats to support most modern clients.

SVRF API Documentation is available at [https://developers.svrf.com][SVRF Dev].

## Access and API Keys

The SVRF API is currently in private beta and access is currently limited to select partners. If you’re interested in using the SVRF API for your app or project, please contact us at [api@svrf.com][API Email]. We cannot guarantee immediate access for all requests, but we will announce a public release in the coming months.

If you have any questions please feel free to contact us at [api@svrf.com][API Email]. Please submit API corrections via [GitHub Issues][]. Please see our [terms of service][TOS] for any restrictions on using the service.

## API Highlights

__Search Endpoint__

[The SVRF Search Endpoint][Docs Search] brings the power of immersive search found on [SVRF.com][SVRF] to your app or project. SVRF's search engine enables your users to instantly find the immersive experience they're seeking. Content is sorted by the SVRF rating system, ensuring that the highest quality content and most prevalent search results are returned.

__Trending Endpoint__

[The SVRF Trending Endpoint][Docs Trending] provides your app or project with the hottest immersive content curated by real humans. The experiences returned mirror the [SVRF homepage][SVRF], from timely cultural content to trending pop-culture references. The trending experiences are updated regularly to ensure users always get fresh updates of immersive content.

## Attribution

__Authors and Site Credit__

At SVRF, we believe in giving credit where credit is due. Please do your best to provide attribution to the `authors` and `site` where the content originated. We suggest using the format: __by {authors} via {site}__

If possible, please provide a way for users to discover and visit the page the content originally came from (`url`).

__Powered By SVRF__

As per our section 5 A of our [terms of service][TOS], __we require all apps that use the SVRF API to conspicuously display "Powered By SVRF" attribution marks where the API is utilized.__ Please provide screenshots of your attribution placement.

## Rate Limits

The SVRF API has a generous rate limit to ensure the best experience for your users. We rate limit by IP address with a maximum of 100 requests per second. If you exceed the rate limit, requests from the requesting IP address will be blocked for 60 seconds.

[API Email]: mailto:api@svrf.com
[CORS]: https://en.wikipedia.org/wiki/Cross-origin_resource_sharing
[Docs Search]: https://developers.svrf.com/#tag/Media/paths/~1vr~1search?q={q}/get
[Docs Trending]: https://developers.svrf.com/#tag/Media/paths/~1vr~1trending/get
[GitHub Issues]: https://github.com/Svrf/svrf-api/issues
[JSON]: http://www.json.org/
[SVRF]: https://www.svrf.com
[SVRF Dev]: https://developers.svrf.com
[TOS]: https://www.svrf.com/terms
