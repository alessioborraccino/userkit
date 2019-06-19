# UserKit

This is the iOS SDK of UserKit™.

It is meant to be a helper SDK that helps iOS app developers to connect with the user service documented at:
http://jsonplaceholder.typicode.com

## Build Instructions

Just clone the project, open the project file with latest stable XCode and build. No third party dependencies required. 

## Usage

Any app which imports the UserKit SDK has direct access to the `UserRepository` class, which has a swiftified CRUD interface
to talk with the server. For instance in order to get all the users:

```
import UserKit

let repository = UserRepository()
repository.getUsers { result in
    switch result {
        case .success(let users):
           //Do something with the users
        case .failure(let error):
           //DO something with the error
    }
}
```

## Architecture

The UserKit framework is divided in 3 parts:

- An internal core networking base, created to reuse code for building all the requests supported by UserKit.
- A model describing the data from UserKit
- A public class which makes use of the internal core and creates a more readable interface for the user, without exposing technical implementations.

### CoreNetworking

Has 3 main components:

- APIEndpoint: Describes the url of the endpoints supported by UserKit.
- APIRequest: Describes the full HTTPRequest including endpoint, http method and body. 
- APIClient: The client which sends a APIRequest returning either an APIError or a decoded model from JSON using Codable.

### Model

- User: The main model, core of UserKit.
- Company: The company where the user works. Optional.
- Address: The address where the user lives. Optional.

### Public interface

The User respository is able to:
- Get all the users
- Get a user identified by an identifier
- Delete user identified by an identifier
- Create user 
- Update user identified by an identifier

Any of these methods have some common traits:
- They have a completion method which could return a successful result, or a UserKitError. 
- They return a token, of class CancellableToken, which could be used to cancel the requests (for instance in case a viewController gets deallocated before the server response)

For extended description of the repository functions, errors, and respective models, see documentation in the code.
For usage examples, see Tests included in the project.

## Assumptions

Some assumptions I took as requirements while developing:

- No need for retrocompatibility with Objective-C, or old iOS Versions. (Due to time constraints)
- No need for authentication or init configurations. (Due to time constraints)
- A User identifier can only be assigned from the backend. That's why specifying the identifier is not possible when initializing a User from the client.
- Users have only name, email and username field mandatory, the rest can be added at any time, and the backend should reflect that.

## Notes

I re-used / adjusted a core networking structure i was already using before in other projects.

While testing the endpoints, i found out some api inconsistencies:
- Calling DELETE on a non existing user will always return success
- Calling PUT on a non existing user will break the backend (returns some xml error)

## Decisions

- No third party dependencies needed, being the safest way to avoid having different versions of sub-dependencies with client projects.
- Repository is intended not to be a singleton, due to the fact that it has no shared state to care about, but just a wrapper.

## Missing (due to time)

- As implemented, the updateUser calls are not able to delete data, just to add it (unless using empty strings and values)
- Any example PATCH call 
- No way to control multithreading from the client (all the calls return to the background thread, which could be dangerous)
- Nested Paths (thought about some builder pattern, or some DSL, GraphQL-like, but no time to go there)
- More error handling (There is no specific error if users already exist, for instance)
- More documentation throughout the code (Docs are not only for the public users, also for developers)
- More tests
- Any way to distribute the framework (Podspec, Carthage file, Package manager..)

