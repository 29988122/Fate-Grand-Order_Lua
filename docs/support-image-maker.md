# Support Image Maker

While the images for many of the common Servants and CEs are present in the `image_SUPPORT` folder, you might want to use some other Servant/CE with `AutoSupportSelection`. You can use the script `_support_img_maker.lua` to create your own images.

Here are the steps you need to follow:

1. Select the `_support_img_maker.lua` script in the AnkuLua app.
2. Open F/GO and go to Support Selection Screen. Alternatively you can also use the Friend List Screen if there are too many flashing icons like drop bonuses.
3. Find the Servant or CE you want to make images for. Make sure the whole Servant + CE block is visible on screen.
4. Execute the script. It finishes almost immediately and the images are saved into a newly created `support_DATETIME` folder.  
   The generated images are black and white, but work fine. So, don't worry about that.
5. Move the images to `image_SUPPORT` folder and rename them as required.
6. Put the filename(s) in the options `Support_PreferredServants` or `Support_PreferredCEs` of the main script, accordingly.

We would appreciate any Pull Requests with useful Servants and CE images, especially for new events.
