AC-Photography-Application
==========================
###Introduction

 - After about a year taking photos as a hobby, I decided it would be intersting to have a standalone application where users could easily view and download images from their smartphone. After about a week of coding, the app was close to being done. Unfortunately, I stopped taking pictures and no longer had a use for this application. Due to this, I slowly finished it and decided to make it public on here so hopefully somebody could use it.

###Libraries

 - MWPhotoBrowser - https://github.com/mwaterfall/MWPhotoBrowser 
       - Requires some optimization for iOS7  
 - FTUtils - https://github.com/neror/ftutils
 - Reachability - https://github.com/tonymillion/Reachability
 - SDWebImage - https://github.com/rs/SDWebImage
 
###Details 

 - The main page contains two main elements: a Featured Images Section and a two sepearate gallery sections. 
       - The Featured Images secition displays 5 images specified in the JSON data. 
       - In my case I have two separate sections for photo galleries so this allows the use to choose which section they want to view.
 - NOTE! The red bar at the bottom of the view is used as a placeholder for ads

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/8116513_orig.png)

 - The main page also contains an information view where I link to my photography website and Facebook page. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/8138601_orig.png)

 - After selecting one of the sections, each of the photo galleries avaliable are displayed
      - The cell for each of the galleries has an image and the number of photos in the gallery 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/6859383_orig.png)

 - Once a gallery is chosen, the user can now view thumbnails for the images. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/6499987_orig.png)

 - When a thumbnail is clicked, it opens up the photo browser. 

![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/4720719_orig.png)

 - From the photo browser, the user can save, copy, and email the image.
 
![screenshot](http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/7653410_orig.png)

###JSON Data 

 - My data was set up to work with my website and with the way my images are organized. In order to make this app work for you, you'll have to create your own data
 - You can view my JSON data in the repo or in the link below 
      - http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/acphoto.json
