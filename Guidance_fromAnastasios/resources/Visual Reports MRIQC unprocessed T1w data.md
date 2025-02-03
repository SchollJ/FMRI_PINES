# Visual Reports MRIQC unprocessed T1w data

In this document we will make notes on how to interpret the visual reports of MRIQC specifically for T1w data.

- For a small intro, resources and Glossary see: Visual Reports MRIQC Unprocessed BOLD data + small intro in the notes of this paper

**For:**

1. **Artifactual structures in the background**
2. **Susceptibility distortion artifacts**
    
    1. **Signal drop-out**
    2. **Brain distortions**
3. **Aliasing ghost**
4. **Wrap-around that overlaps with the brain**
5. **Data formatting issues**

\--> the description is the same as the BOLD reports. For more details see document: Visual Reports MRIQC Unprocessed BOLD data + small intro in the notes of this paper

\--> Note that normalization and co-registration are relative robust to structural images with mild artifacts, therefore it is not always absolute necessity to impose exclusion criteria on the unprocessed T1w images.

**Examples:**

[image]

- **Motion - related and Gibbs ringing: Large head motion during the acquisition of T1w images often expresses itself with the appearance of concentric ripples throughout the scan**
    
    \--> **Gibbs ringing:** is a consequence of the truncation of the Fourier series approximation and appears as **multiple fine lines immediately adjacent and parallel to high contrast interfaces.** But it is the same with subtle cases of motion related issues.
    
    **\--> The ripples cause by motion** generally span the whole brain and are primarily visible in the **sagittal view fo MRIQC’s mosaic view**
    

**For an example see the above image: Figure S10E**

- **Intensity non-uniformity: is characterized by a smooth variation (low spatial frequency) of intensity throughout the brain caused by the strongel signal sensed in the proximity of coils.**
    
    - **Where -->** On the zoomed-in vie on the T1w image
    - Can be a problem for automated processing methods that assume a type of tissue [e.g. white matter (WM)] is represented by voxels of similar intensities across the whole brain.
    - An extreme intensity non-uniformity can also be a sign of coil failure

**For an example see the above image Figure S10F**

- **Eye spillover: Eye movements may trigger the signal leakage from the eyes through the imaging axes with the lowest bandwidth (i.e., acquired faster), potentially overlapping signal from brain tissue.**
    
    - A strong signal leakage can however be noticeable on the zoomed-in view of the T1w image
    - In defaced data the leakage might not be visible

**For an example see the above image Figure S10G**

**Other Notes**

Interpretation of the visual reports of the T1w images based on ([“Introduction to MRIQC [TRAIN-05-2022]”, 2022](zotero://select/library/items/GBRPHHIX))

- **Zoomed-in mosaic view of the brain --> zoomed in brain masks of the T1w images in a horzontal view**
    
    - We want **high contrast between the grey matter and the white matter**
    - We also have to check for **ringing artifacts**
        
- **Background Noise**
    
    - Yellow and green are areas with high background noise
    - Dark purple are areas with lwo background noise

Areas like:

        1) The teeth

        2) Sinus cavities            --> are areas with high background noise

        3) Air canals

[image]

**But: whenever you get in the brain you don’t really want any noise, you want that all purple**

[image]

**\--> And same thing for the saggital view**

[image]