FROM treeder/go-dind

ADD go.sh /scripts/
ADD lib/* /scripts/lib/

# Just for demo and having something here if the user doesn't pass it in
ADD app.go /app/app.go
WORKDIR /app

# Default is to update and install dependencies
ENTRYPOINT ["sh", "/scripts/go.sh"]
