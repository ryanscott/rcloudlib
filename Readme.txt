This library is hosted on github at:

http://github.com/ryanscott/rcloudlib

the git address is:

git@github.com:ryanscott/rcloudlib.git


--
Setting up rcloudlib with a new iPhone project in XCode
--

There are two methods possible, copying source files from rcloudlib project into your target project (not advised), or linking against a static library, which is described below.

Header Search Paths:
${PROJECT_DIR}/../rcloudlib/build/${BUILD_STYLE}-${PLATFORM_NAME}/usr/local/include

source website:
(http://www.amateurinmotion.com/articles/2009/02/08/creating-a-static-library-for-iphone.html)

Linking against static library

To link against a static library while continuing to work with both dependent application and static library we need to:

    * Add a cross-project reference to static library in dependent project
    * Add project to dependent project Target
    * Add static library Product to “Link Binary With Libraries” Build Phase
    * Set static library project as direct dependency to dependent project’s Target
    * Add custom “Header Search Path” to point to static library build output folder

Quite a list of tasks to create this setup but fortunately it’s easy to do. We will start with first.

1. Drag blue LibDemo project icon from “Groups & Files” and drop it inside Client project. Check “Client” in “Add To Targets” table, do not check “Copy items into destination group’s folder” in the sheet what will appear.

2. To link binary with a static library we need to add it to “Linked Libraries” list for binary Target.

Unfold LibDemo.xcodeproj and Targets → Client → Link Binary With Libraries. Drag libDemo.a to Link build phase.

3.  To set libDemo library Target as dependency for Client Target, right click on Client Target, select Get Info then click on General tab. Click add button under Direct Dependencies list, select libDemo.

4.  External headers in Xcode are searched using “Header Search Path” (and “User Header Search Path”) build variables. We need to add libDemo.a public header location to it.  Open “Client” Target info panel (Select Targets → Client and press ⌘I), type “header search” in search field under “Build” tab.

Double-click on “Header Search Path” and add:

${PROJECT_DIR}/../rcloudlib/build/${BUILD_STYLE}-${PLATFORM_NAME}/usr/local/include

5. Add -ObjC to "Other Linker Flags" in the build configurations.  thanks to the following website:

http://www.codingventures.com/2009/04/xcode-templates-for-iphone-static-libraries-with-unit-testing/

The new project should now dynamically build rcloudlib as needed.
