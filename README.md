
This is a Docker image to help you develop in Go (golang). The great thing is you don't need
to have anything installed except Docker, you don't even need Go installed. See [this post about developing with Docker](https://medium.com/iron-io-blog/why-and-how-to-use-docker-for-development-a156c1de3b24).

This image can perform the following functions:

* vendor - vendors your dependencies into a /vendor directory.
* build - builds your program using the vendored dependencies, with no import rewriting.
* remote - this one will produce a binary from a GitHub repo. Equivalent to cloning, vendoring and building.
* image - this will build and create a Docker image out of your program.
* cross - cross compile your program into a variety of platforms. Based on [this](https://medium.com/iron-io-blog/how-to-cross-compile-go-programs-using-docker-beaa102a316d#95d9).
* static - statically compile your program. This is great for making the [tiniest Docker image possible](http://www.iron.io/blog/2015/07/an-easier-way-to-create-tiny-golang-docker-images.html).

## Usage

### Vendor dependencies:

```sh
docker run --rm -v $PWD:/app -w /app treeder/go vendor
```

### Build:

```sh
docker run --rm -v $PWD:/app -w /app treeder/go build
```

### Run:

This is just a normal Docker run. I'm using iron/base here because it's a tiny image that has
everything you need to run your Go binary on.

```sh
docker run --rm -v $PWD:/app -w /app -p 8080:8080 iron/base ./app
```

## Advanced Commands

### Build a remote git repo:

This produces a binary given a remote git repo containing a Go program.

```sh
docker run --rm -v $PWD:/app -w /app treeder/go remote https://github.com/treeder/hello-app.go.git
```

You'll end up with a binary called `app` which you can run with the same command as above.

### Build a Docker image out of your program:

This will build a Docker image with your program inside it.

The argument after image is `IMAGE_NAME:tag`. Also, note the extra mount here, that's required to talk to the Docker host.

```sh
docker run --rm -v $PWD:/app -w /app -v /var/run/docker.sock:/var/run/docker.sock treeder/go image username/myapp:latest
```

Boom, creates a small Docker image for you. Run `docker images` to check it out, should be about ~12MB total.

Test your new image:

```sh
docker run --rm -v $PWD:/app -w /app -p 8080:8080 username/myapp
```

### Cross compile:

This uses a different image, treeder/go-cross, to do a cross compile.

```sh
docker run --rm -v $PWD:/app -w /app treeder/go-cross cross
```

### Build static binary:

This is great for making the [tiniest Docker image possible](http://www.iron.io/blog/2015/07/an-easier-way-to-create-tiny-golang-docker-images.html)

```sh
docker run --rm -v $PWD:/app -w /app treeder/go static
```

### Check Go version:

```sh
docker run --rm treeder/go version
```

## TODO:

...

## Building this image

```sh
docker build -t treeder/go:latest .
```

Tag it with Go version too (can check with `docker run --rm treeder/go version`):

```sh
docker tag treeder/go:latest treeder/go:1.4.2
```

Push:

```sh
docker push treeder/go
```
