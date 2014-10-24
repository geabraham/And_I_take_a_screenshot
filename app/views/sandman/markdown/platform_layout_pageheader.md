## The Page Header and Application Content

The page header is the blue bar un der the navigation. While this space is technically the the responsibility of the application, it is vital that the html is strictly applied here. Rails apps have developed a partial structure to make this eaiser (to be docuemented). There are two sections in the page header that accept content from the application, and only the text is required at minimum to provide some context to the page.

Below the page header is the main div, where all other applicaiton content is to be included. 

Following this structure is key, since once an app is checkmated, everything in this area is what checkmate will render into it's layout. Not adhereing to the rules here can cause problems later when checkmating.