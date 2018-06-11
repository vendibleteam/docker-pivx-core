# marsmensch/docker-pivx-core

A PIVX Core docker image. Based on Alpine Linux with Berkeley DB 4.8 (cross-compatible build), targets a specific version branch or release of PIVX Core.

## What is PIVX?
_from [the pivx website](https://pivx.org/what-is-pivx/)_

PIVX is a form of digital online money using blockchain technology that can be easily transferred all around the world in a blink of an eye with nearly non-existent transaction fees with market leading security & privacy. https://pivx.org

## Usage

This image is meant to be built locally like this (choose any name / tag):

```sh
$ docker build -t marsmensch/pivx-testbox . 
```

### How to use this image

This image contains the main binaries from the PIVX Core project - `pivxd`, `pivx-cli` and `pivx-tx`. It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `pivxd` binary:

```sh
$ docker run --rm --name pivx-testnet -it marsmensch/pivx-testbox \
  -printtoconsole \
  -testnet=1 \
  -rpcallowip=172.17.0.0/16 \
  -rpcpassword=bar \
  -rpcuser=foo
```

By default, `pivxd` will run as user `pivx` for security reasons and with its default data dir (`~/.pivx`). If you'd like to customize where `pivx-core` stores its data, you must use the `PIVX_DATA` environment variable. The directory will be automatically created with the correct permissions for the `pivx` user and `pivx-core` is automatically configured to use it.

```sh
$ docker run --env PIVX_DATA=/var/lib/pivx --rm --name pivx-testnet -it marsmensch/pivx-testbox \
  -printtoconsole \
  -testnet=1
```

You can also mount a directory it in a volume under `/home/pivx/.pivx` in case you want to access it on the host:

```sh
$ docker run -v ${PWD}/data:/home/pivx/.pivx -it --name pivx-testnet --rm marsmensch/pivx-testbox \
  -printtoconsole \
  -regtest=1
```

### Using RPC to interact with the daemon

There are two communications methods to interact with a running PIVX Core daemon.

The first one is using a cookie-based local authentication. It doesn't require any special authentication information as running a process locally under the same user that was used to launch the PIVX Core daemon allows it to read the cookie file previously generated by the daemon for clients. The downside of this method is that it requires local machine access.

The second option is making a remote procedure call using a username and password combination. This has the advantage of not requiring local machine access, but in order to keep your credentials safe you should use the newer `rpcauth` authentication mechanism.

#### Using cookie-based local authentication

Start by launch the PIVX Core daemon:

```sh
❯ docker run --rm --name pivx-testnet -it marsmensch/pivx-testbox \
  -printtoconsole \
  -testnet=1
  -rpcuser=foo
  -rpcpassword=bar
```

Then, inside the running `pivx-server` container, locally execute the query to the daemon using `pivx-cli`:

```sh
❯ docker exec --user pivx pivx-testnet pivx-cli -testnet -rpcuser=foo -rpcpassword=bar getmininginfo

{
  "blocks": 14049,
  "currentblocksize": 0,
  "currentblocktx": 0,
  "difficulty": 120687.3790991092,
  "errors": "",
  "genproclimit": -1,
  "networkhashps": 8144643474489,
  "pooledtx": 0,
  "testnet": true,
  "chain": "test",
  "generate": false,
  "hashespersec": 0
}
```

In the background, `pivx-cli` read the information automatically from `XXXXXXXXXXXLALALALALALALLALA/home/pivx/.pivx/testnet/.cookie`. In production, the path would not contain the regtest part.


## Supported Docker versions

This image is officially supported on Docker 18 CE, with support for older versions provided on a best-effort basis.

## License

[License information](https://github.com/PIVX-Project/PIVX/blob/master/COPYING) for the software contained in this image.
[License information](https://github.com/uphold/docker-dash-core/blob/master/LICENSE) for the [uphold/dash-core][docker-hub-url] docker project.
[License information](https://github.com/marsmensch/docker-dash-core/blob/master/LICENSE) for my modifications in this repository.