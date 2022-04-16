![Pin Bin logo](https://github.com/jdesilvio/pin-bin/blob/master/pinbin-logo-bw.png)

---

The inspiration for this application came when I moved to Philadelphia.
I saw a lot of cool restaurants, bars, and stores that I wanted to
remember to go to. I started making a list, but then I'd never remember
to refer to the list.

What I wanted was **a simple system for filing away place of interest
AND a smart alert system** to tell me when I was close to one of them
or present me with suggestions at times that I am likely to be looking
for a place to eat, shop or hangout.

**Add more stuff here**
---

## API Usage

### Sign up and authentication

```bash
# Sign up for a new account
$ curl -X POST http://localhost:4000/api/v1/sign_up?email=<EMAIL_ADDRESS>&username=<USERNAME>&password=<PASSWORD>

# Get an API JSON Web Token (JWT)
$ curl -X POST http://localhost:4000/api/v1/auth?email=<EMAIL_ADDRESS>&password=<PASSWORD>
```

### Use a JWT to access API endpoints

```bash
## /users

# List users
$ curl -X GET http://localhost:4000/api/v1/users -H 'Authorization: Bearer <JWT>'

# Get details of a user
$ curl -X GET http://localhost:4000/api/v1/users/1 -H 'Authorization: Bearer <JWT>'


## /bins

# List a users' bins
$ curl -X GET http://localhost:4000/api/v1/users/1/bins -H 'Authorization: Bearer <JWT>'

# Get details of a bin
$ curl -X GET http://localhost:4000/api/v1/users/1/bins/1 -H 'Authorization: Bearer <JWT>'

# Create a bin
$ curl -X POST http://localhost:4000/api/v1/users/1/bins -H 'Authorization: Bearer <JWT>' -d '{"bin": {"name": "my bin"}}'

# Update a bin
$ curl -X PATCH http://localhost:4000/api/v1/users/1/bins/1 -H 'Authorization: Bearer <JWT>' -d '{"bin": {"name": "new name"}}'

# Delete a bin
$ curl -X DELETE http://localhost:4000/api/v1/users/1/bins/1 -H 'Authorization: Bearer <JWT>'


## /pins

# List a users' pins
$ curl -X GET http://localhost:4000/api/v1/users/1/bins/1/pins -H 'Authorization: Bearer <JWT>'

# Get details of a pin
$ curl -X GET http://localhost:4000/api/v1/users/1/bins/1/pins/1 -H 'Authorization: Bearer <JWT>'

# Create a pin
$ curl -X POST http://localhost:4000/api/v1/users/1/bins/1/pins -H 'Authorization: Bearer <JWT>' -d '{"bin": {"name": "my pin", "latitude": 39.9526, "longitude": -75.1652}}'

# Update a pin
$ curl -X PATCH http://localhost:4000/api/v1/users/1/bins/1/pins/1 -H 'Authorization: Bearer <JWT>' -d '{"bin": {"name": "new name"}}'

# Delete a pin
$ curl -X DELETE http://localhost:4000/api/v1/users/1/bins/1/pins/1 -H 'Authorization: Bearer <JWT>'


## /yelp

# Get nearby businesses from the Yelp Fusion API
$ curl -X GET http://localhost:4000/api/v1/yelp?latitude=39.9526&longitude=-75.1652
```
