#  WildAid O-FISH iOS App

The [WildAid Marine Program](https://marine.wildaid.org/) work to protect vulnerable marine environments.

O-FISH (Officer Fishery Information Sharing Hub) is a multi-platform application that enables officers to browse and record boarding report data from their mobile devices.

This repo implements the iOS O-FISH app.

## Prerequisites

This is the iOS Mobile app for O-FISH. To build and use the app, you must first create and configure your serverless backend application using the [WildAid O-FISH MongoDB Realm repo](https://github.com/WildAid/o-fish-realm)

## Building and running the app

Build and run the app using Xcode - but before building, set the Realm Application ID (find it for your app through the [MongoDB Realm UI](https://realm.mongodb.com)) in `o-fish/Helpers/Constant.swift`:

```
realm_app_id=your_app_id
```

Before using the app, you need to create a user in your instance of the [O-FISH Realm App](https://github.com/WildAid/o-fish-realm).

