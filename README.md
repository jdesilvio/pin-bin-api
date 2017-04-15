# Blaces

The inspiration for this application came when I moved to Philadelphia. I saw a lot of cool restaurants, bars, and stores that I wanted to remember to go to. I started making a list, but then I'd never remember to refer to the list.

What I wanted was **a simple system for filing away place of interest AND a smart alert system** to tell me when I was close to one of them or present me with suggestions at time that I am likely to be loking for a place to eat, shop or hangout...


### The general scope of this app:

* Mobile only
* Uses geo-location and the Yelp API to determine places in the user's immediate proximity
* An elegant, minimal UI:
    * Wake-up screen that presents potential places of interest and a mechanism for getting them to a bucket or discarding them
    * A way for users to manage buckets (should be no more than 4 buckets for screen real estate reasons)
    * A way for users to explore their buckets
    * Alert settings
    * Account settings

### Examples:

#### _API_

    # Get your API JSON Web Token (jwt)
    curl -X POST 'http://localhost:4000/api/v1/auth?email=<EMAIL_ADDRESS>&password=<YOUR_PASSWORD>'

    # Use your jwt access API endpoints
    curl -H "Authorization: Bearer <jwt>" http://localhost:4000/api/v1/users/2

    # Yelp endpoint
    http://localhost:4000/api/v1/yelp?latitude=40&longitude=-75

#### _Browser_

    http://localhost:4000/yelp
