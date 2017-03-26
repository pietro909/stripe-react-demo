# Stripe and React demo
## Customers' CRUD application using Stripe API and React with Elm.

Sample project.

Additional libraries:

* [Elm](http://www.elm-lang.org/) for state and effects management
* [Bootstrap](http://getbootstrap.com/) as UI framework

This project template was built with [Create React App](https://github.com/facebookincubator/create-react-app), then ejected to customize Webpack's configuration.

Using [Stripe API](https://stripe.com/docs/api#list_customers) for customers' management.

## Before running

Make sure you get you own API key from Stripe and put it in the `.env` file with the format:

```
REACT_APP_API_KEY=sk_test_yoursupersecretapikey
```

Then run the installers:

```
$ npm install
$ elm install
```

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br>
You will also see any lint errors in the console.

### `npm run build`

Builds the app for production to the `build` folder.<br>
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br>
Your app is ready to be deployed!
