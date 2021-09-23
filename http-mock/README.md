# Mountebank HTTP Server

For more info, see [Mountebank](http://www.mbtest.org/docs/gettingStarted)

```shell
docker run \
    -v $(pwd):/imposters \
    --rm -p 2525:2525 -p 4545:4545 bbyars/mountebank:2.5.0 \
    mb start --configfile /imposters/imposters.ejs --allowInjection --loglevel debug
```