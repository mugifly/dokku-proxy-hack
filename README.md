# dokku-proxy-hack

This little hacks allows you to using the Dokku-alt (Dokku alternative) in the proxy environment.

This project is VERY EXPERIMENTALLY.

However, I also hope that proxy problem of Docker (and dokku-alt) is resolved by [support](https://github.com/docker/docker/issues/4962) of Docker itself.

## Steps for dokku-alt

This steps tested in Ubuntu 14.04 LTS & dokku-alt v0.3.10-7-gf34bb41.

### 0. Setting for apt

Please edit the following files.

**/etc/apt.conf**

```txt
export http_proxy="http://proxy.example.com:8080/"
export https_proxy="http://proxy.example.com:8080/"
```

### 1. Installing of dokku-alt

Firstly, please install dokku-alt.
Then complete the initial setup by access to ```http://<ip>:2000/```.

https://github.com/dokku-alt/dokku-alt#installing

### 2. Setting for docker and dokku

Please edit the following files.

**/etc/default/docker**

```txt
export http_proxy="http://proxy.example.com:8080/"
export https_proxy="http://proxy.example.com:8080/"
```

**/home/dokku/.bashrc**
```txt
# Proxy
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
```

**/home/dokku/.gitconfig**

```txt
[http]
        proxy = http://proxy.example.com:8080
[https]
        proxy = http://proxy.example.com:8080
```

### 3. Deploying of this script

Run the following commands on your dokku server.

	$ cd /home/dokku/
    $ git clone https://github.com/mugifly/dokku-proxy-hack.git
	$ chown dokku:dokku dokku-proxy-hack/ -R
	$ cd dokku-proxy-hack/
	$ chmod u+x dockerfile_rewriter.sh

### 4. Inserting code for using proxy on docker build

Firstly, Please edit the head of this file as the followin code:  **/var/lib/dokku-alt/plugins/dokku-rebuild/commands**

```bash
#!/usr/bin/env bash

source "$(dirname $0)/../dokku_common"

http_proxy="http://proxy.example.com:8080/"
https_proxy="http://proxy.example.com:8080/"
```


Then, Insert the following code into previous line of **docker build** in the foregoing file.

    /home/dokku/dokku-proxy-hack/dockerfile_rewriter.sh http_proxy=$http_proxy https_proxy=$https_proxy

Example of inserting - Before:

```bash
docker build --no-cache=true -t "$IMAGE" .
```

Example of inserting - After:

```bash
/home/dokku/dokku-proxy-hack/dockerfile_rewriter.sh http_proxy=$http_proxy https_proxy=$https_proxy
docker build --no-cache=true -t "$IMAGE" .
```

### 5. Inserting code for using proxy on docker run

Insert the following parameters into the line of **docker run** in dokku-alt script.

    --env "http_proxy=${http_proxy}" --env "https_proxy=${https_proxy}"

Example of inserting - Before:

```bash
docker run -i -a stdin "$IMAGE"
```

Example of inserting - After:

```bash
docker run -i -a stdin --env "http_proxy=${http_proxy}" --env "https_proxy=${https_proxy}" "$IMAGE"
```

In normally, you should add that parameters into following files:

* /var/lib/dokku-alt/plugins/dokku-rebuild/commands
* /usr/local/bin/dokku

### 6. Ready?

Let install the dokku-alt-manager.
It allows you management of dokku with using the web-based GUI.

    $ dokku manager:install

If it was successful, It means able to connect via proxy.
