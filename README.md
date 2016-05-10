# jekyll-arm

A quick & dirty jekyll container based on [armbuild/debian][1].

## Requirements

* an ARM machine
* SSL cert + key
* a parsed Jekyll site (but anything that can be served by nginx will do, really)


## Why & how

Yesterday I finally put up some content on [vanduuren.xyz][2] using Jekyll to generate the site. I made some typos, forgot some words, so I had to manually redeploy a few times. This image fixes that problem for me.
The image contains a simple nginx instance serving the Jekyll site over SSL and a script that pulls the latest build every five minutes.

To run:

```bash
docker run -d	\
	-e GIT_URL=https://github.com/boyvanduuren/vanduuren.xyz.git \
	-e GIT_BRANCH=live \
	-e DOMAIN=vanduuren.xyz \
	-v /etc/ssl/private/:/etc/ssl/private/ \
	-p 80:80 \
	-p 443:443 \
	boyvanduuren/docker-jekyll
```

* `GIT_URL` is the URL of the repository containing your (built!) Jekyll site
* `GIT_BRANCH` is the branch that contains the "live" version of the site
* `DOMAIN` is the domain at which this site is served. A redirect from `www.${DOMAIN} -> ${DOMAIN}` is configured

Furthermore, the shared volume needs to contain a SSL certificate and key named `${DOMAIN}.{key,crt}`.

When this is running, all you need to do to update the site in the container is update your Jekyll site, run `jekyll build`, and push your changes to the configured `GIT_BRANCH` branch.
Of course I need to setup a decent delivery pipeline when I have some more time, but this works for now.

[1]: https://hub.docker.com/r/armbuild/debian/
[2]: https://vanduuren.xyz
