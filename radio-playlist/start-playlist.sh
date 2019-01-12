#/bin/sh

# Copy My web radios till problem is fixed
cp /home/volumio/my-web-radio /data/favourites/my-web-radio

volumio=localhost:3000/api/v1/commands
until $(curl --silent --output /dev/null --head --fail ${volumio}); do
   echo "We wait till volumio is up and running"
   sleep 10s
done

sleep 20s
echo "Volumio server is running, so we can launch our playlist"
curl localhost:3000/api/v1/commands/?cmd='playplaylist&name=PL_Classic21'