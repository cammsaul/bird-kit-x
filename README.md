Highly useful helper functions, classes, and categories.

View the documentation at http://cammsaul.github.io/bird-kit-x/. Doing a production build will also generate the documentation and automatically install into Xcode, and can be viewed via Xcode -> Help -> Documentation and API Reference.

The X iOS Platform Offers several useful components, such as:

**XNavigationSerivce**

Navigate to view controllers by passing parameters, similar to the way activities are pushed in Android.

     [XNavigationService navigateTo:@"VenueDetailsViewController" params:@{ParamKeyVenueID: @(ID)}];

The destination view controller can check to make sure all expected parameters are present by implementing `validateParams:`

    + (void)validateParams:(NSDictionary *)params {
        NSNumber * const venueID = params[ParamKeyVenueID];
        NSParameterAssert(venueID && [venueID isKindOfClass:NSNumber.class] && venueID.intValue);
    }

the params are then made available via `self.params`.

**XLogging**

Faster, more flexible, and less messy than NSLog, and automatically gets compiled out for production builds

    XLog(self, LogFlagInfo, @"User %d", userID); // will output "[MyClass Info] User 20" to the console

Set the level of logging:

    *XLogLevel = LogLevelWarn; // Don't log things tagged with LogFlagInfo or LogFlagVerbose

Restrict logging to certain classes (you can even do this at runtime via lldb):

    // now only messages from VenueDetailsViewController will be logged
    (lldb) po XLogClasses = (NSSet *)[NSSet setWithObject:[VenueDetailsViewController class]]
