#!/bin/sh

# check for variables
if [ -z $GIT_URL ] || [ -z $GIT_BRANCH ] || [ -z $DOMAIN ]; then
  exit 1
fi

# check for ssl files
SSL_DIR=/etc/ssl/private
if [ ! -f ${SSL_DIR}/${DOMAIN}.key ] || [ ! -f ${SSL_DIR}/${DOMAIN}.crt ]; then
  exit 1
fi

REPO_DIR=/srv/jekyll

# clone jekyll site from given URL
git clone -b $GIT_BRANCH $GIT_URL $REPO_DIR
chown -R www-data: $REPO_DIR

# substitute some vars in jekyll.conf
sed -i "s/\${DOMAIN}/${DOMAIN}/g" /etc/nginx/conf.d/jekyll.conf

/usr/bin/runsvdir -P /etc/service
