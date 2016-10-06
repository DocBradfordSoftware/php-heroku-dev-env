# php-heroku-dev-env

```yaml

version: "2"
services:

bash:
    #build: devapps/php
    image: docbradfordsoftware/php-heroku-dev-env:1.0
    volumes:
      - ./root:/root
      - ./projects:/projects

```