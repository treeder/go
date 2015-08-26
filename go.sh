# To test this script before building an image:
# docker run --rm -v $PWD:/app -w /app treeder/go-dind sh go.sh version

# Original command to vendor
# docker run --rm -it -v "$PWD":/go/src/x/y/z -w /go/src/x/y/z -e "GOPATH=/go/src/x/y/z/vendor:/go" golang go get
# Original command to build
# docker run --rm -it -v $PWD:/go/src/x/y/z -w /go/src/x/y/z -e "GOPATH=/go/src/x/y/z/vendor:/go" golang go build -o hello
# Original command to cross compile:

set -e

cmd="$1"
# echo "Args: $*"
if [ "$#" -lt 1 ]
then
    echo "No command provided."
    exit 1
fi

# echo $PWD
wd=$PWD
p=/go/src/x/y/z
mkdir -p $p
if [ `ls -A $wd` ]
  then
    # only if files exist, errors otherwise
    cp -r * $p
fi
cd $p
# Add vendor to the GOPATH so get will pull it in the right spot
export GOPATH=$p/vendor:/go
# env

# Pass in: $# MIN_ARGS
validate () {
  if [ "$1" -lt $2 ]
  then
      echo "No command provided."
      exit 1
  fi
}
vendor () {
  go get
  cp -r $1/vendor $2
  chmod -R a+rw $2/vendor
  #      cd $wd
}
build () {
  # echo "build: $1 $2"
  go build $1
  cp app $2
  chmod a+rwx $wd/app
}

case "$1" in
  vendor)  echo "Vendoring dependencies..."
      vendor $p $wd
      ;;
  build)  echo  "Building..."
      build "-o app" $wd
      ;;
  cross)  echo  "Cross compiling..."
      for GOOS in darwin linux windows; do
        for GOARCH in 386 amd64; do
        echo "Building $GOOS-$GOARCH"
        export GOOS=$GOOS
        export GOARCH=$GOARCH
        go build -o bin/app-$GOOS-$GOARCH
        done
      done
      cp -r bin $wd
      chmod -R a+rw $wd/bin
#      ls -al $wd/bin
      ;;
  static) echo  "Building static binary..."
      CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o static
      cp static $wd
      chmod a+rwx $wd/static
      ;;
  remote) echo  "Building binary from $2"
      validate $# 2
      userwd=$wd
      cd
      git clone $2 repo
      cd repo
      wd=$PWD
      # Need to redo some initial setup here:
      cp -r * $p
      cd $p
      vendor $p $wd
      build "-o app" $wd
      cp $wd/app $userwd
      chmod a+rwx $userwd/app
      ;;
  image) echo  "Building Docker image '$2'..."
      validate $# 2
      ls -al /usr/bin/docker
      build "-o app" $wd
      /usr/bin/docker version
      cp /scripts/lib/Dockerfile $p
      /usr/bin/docker build -t $2 .
      # perhaps an alternative to this would be to do dind, replace the FROM with treeder/go-dind for example:
#      cp /scripts/lib/Dockerfile $p
#      /usr/bin/dockerlaunch /usr/bin/docker -d -D &
#      sleep 3
#      docker build -t $2 .
      ;;
  version)
      go version
      ;;
  *) echo "Invalid command, see https://github.com/treeder/dockers/tree/master/go for reference."
      ;;
esac
exit 0
