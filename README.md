AC-Photography-Application
==========================
##Introduction

 - After about a year taking photos as a hobby, I decided it would be interesting to have a standalone application where users could easily view and download images from their smartphone.

##Libraries

 - MWPhotoBrowser - https://github.com/mwaterfall/MWPhotoBrowser 
 - Reachability - https://github.com/tonymillion/Reachability
 - SDWebImage - https://github.com/rs/SDWebImage
 
##Details 

 - Compatible with iOS 6.0 +

###JSON Data 

 - My data was set up to work with my website and with the way my images are organized. In order to make this app work for you, you'll have to create your own data
 - You can view my JSON data in the repo or in the link below 
      - http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/acphoto.json
 - I included a small script that generates JSON data from Flickr sets. Simply run `sh test.sh` then enter the link to the gallery's sets (Ex: `http://www.flickr.com/photos/38177739@N05/sets/`)
      - The script will then create data including an object with the titles of each of the sets and then an object for each set with the urls to the images.
     
![script](https://raw.github.com/acompagno/AC-Photography-Application/master/AC%20Photo/Images/ScriptScreenshot.png)

###Main View

 - The main page contains two main elements: a Featured Images Section and a two sepearate gallery sections. 
       - The Featured Images secition displays 5 images specified in the JSON data. 
       - In my case I have two separate sections for photo galleries so this allows the use to choose which section they want to view.

![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/1.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/1.png)

###Information View

 - The main page also contains an information view where I link to my photography website and Facebook page. 

![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/2.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/2.png)

###Gallery Selection View

 - After selecting one of the sections, each of the photo galleries avaliable are displayed
      - The cell for each of the galleries has an image and the number of photos in the gallery 

![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/3.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/3.png)

###Thumbnail Gallery

 - Once a gallery is chosen, the user can now view thumbnails for the images. 

![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/4.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/4.png)

###Photo Browser

 - When a thumbnail is clicked, it opens up the photo browser. 

![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/5.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/5.png)

 - From the photo browser, the user can save, copy, and email the image.
 
![iOS7screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS7Screenshots/6.png) ![iOS6screenshot](https://raw.github.com/acompagno/AC-Photography-Application/master/Images/iOS6Screenshots/6.png)

##License 

Copyright (c) 2013 Andre Compagno 
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
