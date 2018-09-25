![Pin Bin logo](https://github.com/jdesilvio/pin-bin/blob/master/pinbin-logo-bw.png)

---

The inspiration for this application came when I moved to Philadelphia. I saw a lot of cool restaurants, bars, and stores that I wanted to remember to go to. I started making a list, but then I'd never remember to refer to the list.

What I wanted was **a simple system for filing away place of interest AND a smart alert system** to tell me when I was close to one of them or present me with suggestions at time that I am likely to be loking for a place to eat, shop or hangout...


### The general scope of this app:

* Mobile only
* Uses geo-location and the Yelp API to determine places in the user's immediate proximity
* An elegant, minimal UI:
    * Wake-up screen that presents potential places of interest and a mechanism for getting them to a bin or discarding them
    * A way for users to manage bins (should be no more than 4 bins for screen real estate reasons)
    * A way for users to explore their bins
    * Alert settings
    * Account settings

### Examples:

#### _API_

    # Sign up for a new account
    $ curl -X POST 'http://localhost:4000/api/v1/sign_up?email=<EMAIL_ADDRESS>&username=<USERNAME>&password=<PASSWORD>'

    # Get your API JSON Web Token (JWT)
    $ curl -X POST 'http://localhost:4000/api/v1/auth?email=<EMAIL_ADDRESS>&password=<PASSWORD>'

    # Use your JWT to access API endpoints
    $ curl -H "Authorization: Bearer <JWT>" http://localhost:4000/api/v1/users
    $ curl -H "Authorization: Bearer <JWT>" http://localhost:4000/api/v1/users/1

    # Yelp endpoint
    $ http://localhost:4000/api/v1/yelp?latitude=40&longitude=-75

#### _Browser_

    http://localhost:4000/yelp
