# README
<<<<<<< HEAD
<<<<<<< Updated upstream

This README would normally document whatever steps are necessary to get the
application up and running.
=======
# Customizable calculator
### by: Sajed Almorsy -  sajed.almorsy@gmail.com
It is a customizable calculator application, currently, only the binary operations are supported with the following operations: (Addition, Subtraction, Multiplication, Division)

The operations results are cached for faster future access. 

The view is rendered dynamically using  configuration data that is sent by the server.
>>>>>>> Stashed changes
=======
# OnePageCrm - RUBY ON RAILS CODING TEST
### by: Sajed Almorsy -  sajed.almorsy@gmail.com
It is a customizable calculator application, currently, only the binary operations are supported with the following operations: (Addition, Subtraction, Multiplication, Division)

The view is rendered dynamically using  configuration data that is sent by the server.
>>>>>>> be0e050... Add README.md file.

Appending a new binary operation will require only adding the operation meta data to the array of supported binary operations at `Operation::BinaryOperation` and that's it, you
won't even need to update the view as it's rendered dynamically.
* Environment
    -
    - Ruby v3.0.1 - latest stable as by 8 May 2021
    - Rails v6.1.3.2 - latest stable as by 8 May 2021
    - Node v14.16.1 - latest stable as by 8 May 2021
    - mongoDB v4.4.5 - latest stable as by 8 May 2021

* System dependencies
    -
    - webpack, react, babel, jquery, bootstrap for the front end.
    - Rspec for testing.

* Database creation
    -
    - To development & testing, just use the mongoDB default configurations
    - For production, add the configurations to env variables
      then customize `config/mongoid.yml` file as needed

* How to run the test suite
    -
    - To run all the tests use: `bundle exec rspec`.
    - To run the model tests only, use: `bundle exec rspec spec/models`
    - To run the routing tests only, use: `bundle exec rspec spec/routing`
    - To run the controllers/requests tests only, use: `bundle exec rspec spec/requests`
    - Test suites for the views are not supported.


* Deployment instructions
    -
    - Setup the environment by installing the softwares in the environment section
    - From the project root directory, run:
    ```
      $ bundle install
      $ npm install
      $ rails s
    ```

* TODO
  -
  - Update the `.gitignore` file