This library is hosted on github at:

http://github.com/ryanscott/rcloudlib

the git address is:

git@github.com:ryanscott/rcloudlib.git


--
Setting up rcloudlib with a new iPhone project in XCode
--


There are two suggested methods possible:

1. add files from rcloudlib to your project as links, not copies (advised for projects you are actively developing)
	- advantage: you will automatically get rcloudlib updates, as you pull updates down
	- disadvantage: the rcloudlib files may change, and that may require you make changes to your code (usually very trivial)
									this is typically only a problem whtn the project is not being actively worked on
2. copy source files from rcloudlib project into your target project (advised to protect against library changes)
	- advantage: you know that the rcloudlib files are not going to change out from under you
	- disadvantage: you will not get updates, without manually updating your local copy, then re-copying the files into your project

Depending on your project, choose the integration method that makes the most sense.  I no longer recommend linkning rcloudlib as an externally built library, but if you want to do it anyway, rcloudlib does support it, and there are instructions on how to do it all over the web.

Optional Instuctions:

1.  Add rcloudlib.h to the new project PCH. This removes the need to manually include library headers.  
		a mater of style and preference.  I personally really like it, and use it in every project in which I use rlcoudlib.
		

If you encounter problems or bugs, or have suggestions, contributions, please get involved and contribute to the lib.  I actively develop the code, and welcome any and all help and new ideas.

Thanks
Ryan