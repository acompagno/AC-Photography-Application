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
     
![script](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/4493560_orig.png)

###Main View

 - The main page contains two main elements: a Featured Images Section and a two sepearate gallery sections. 
       - The Featured Images secition displays 5 images specified in the JSON data. 
       - In my case I have two separate sections for photo galleries so this allows the use to choose which section they want to view.

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/8116513_orig.png)

###Information View

 - The main page also contains an information view where I link to my photography website and Facebook page. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/8138601_orig.png)

###Gallery Selection View

 - After selecting one of the sections, each of the photo galleries avaliable are displayed
      - The cell for each of the galleries has an image and the number of photos in the gallery 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/6859383_orig.png)

###Thumbnail Gallery

 - Once a gallery is chosen, the user can now view thumbnails for the images. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/6499987_orig.png)

###Photo Browser

 - When a thumbnail is clicked, it opens up the photo browser. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/4720719_orig.png)

 - From the photo browser, the user can save, copy, and email the image.
 
![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/7653410_orig.png)

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
