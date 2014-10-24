

### Doctype and HTML opening tag
The Doctype is a required element of any proper html page and ensures that the browser is in standards mode, helping maintin a consistent environment to develop web pages against. We use the HTML5 Doctype, which is short and easy to remember, and gets the job done.

The opening HTML tag follows, surrounded by IE conditional comments and with a no-js class added to it.

the IE conditional comments are only used by IE, and add a class that identifies the version of IE which has loaded the page. Only IE can read these conditionals, and renders the HTML tag that meets the condition. There classes are used in the CSS to write css targeted for that version of IE to fix any rendering issues that are specific to IE and require additional CSS.

The no-js class is always added, regardless of the conditionals, and is for use with Modernizr for feature detection and additional styling. On initialization, Modernizr will replace this class with a js class, showing that the browser supports javascript. If the no-js class is not replaced, the browser does not support javascript of the user has it turned off, and the no-js class can be used to for styling elements and interactions in a way that works with no javascript.

### The Head Tag

The head tag contains a few more vital elements:

```meta charset``` - a required element that sets the charachter encoding to UTF-8.

```meta http-equiv="X-UA-Compatible"``` - this meta tag forces IE to use the latest version of the rendering engine(IE 8 and 9 include multiple rendering engines to support it's various rendering modes). This tag also triggers IE to use Chrome frame (an IE plugin that uses the Chrome rendering engine.) if it is installed.

NOTE: Chrome frame has been discontinued, but we are leaving this in for people who may still have it installed and like to use it.

```meta viewport``` - default setting for mobile devices which helps scaling and orientation on mobile browsers

Modernizr - This javacript library provides HTML5 compatability to legacy browsers by creating elements that the browser doe snot natively support, and provides a way to test for browser features and load additional javascript ot add HTML5 features to older browsers, mainly IE 7 and 8

#### stylesheet link tags
platform.css - includes the Bootstrap framework with MCC additions for theme and widget support
application.css - this will be application specific CSS

###The Body Tag
The body tag is where the application content will live. The specific format for the body tag is described in the Platform Layout.

The only hard and fast rule we have about the body tag is that javascripts should always be included right before the closing body tag and no where else, except the scripts required in the head. There are some exceptions to this rule, but for performance and best practices reasons, it is always best to only include scripts at the bottom of the page and nowhere else. Especially inline javascript or embeded script tags within the application content.

__Note on JavaScript Placement__ - the one and most common exception to the rule of placing JavaScripts before the closing body tag is for applications that are supporting legacy code and will need to include jQuery or other libraries in the head tag. This is normally needed when applications have in-line or embedded JavaScript that references a library before the end of the body tag. If the library is not loaded yet, this will always casue an error and may prevent the page from executing and displaying properly. In this case, pleae include the required library in the head tag and work on moving your application to use more unobtrusive JavaScript where possible.
