# Visual Reports MRIQC Unprocessed BOLD data + small intro

## Intro and Glossary

In this document we will try to build a document on how to visually inspect the MRIQC and fMRIPrep visual outputs.

For this are going to use several resources:

**Main Resource** will be the paper that these notes are attached to --> ([Provins et al., 2023](zotero://select/library/items/KSI3K2X5))

**But also see:**

- [https://www.youtube.com/watch?v=In6Dez_uuxQ&t=1s](https://www.youtube.com/watch?v=In6Dez_uuxQ&t=1s) --> video toturial on youtube on how to set up and interpret fmriqc by Matt Defenderfer of UAB research computing
- [https://sarenseeley.github.io/BIDS-fmriprep-MRIQC.html#Usage30](https://sarenseeley.github.io/BIDS-fmriprep-MRIQC.html#Usage30) --> Very helpful and well structured notes (main inspiration for this document) from Saren Seeley on BIDS, FMRIQC and fmriprep
- [https://docs.google.com/document/d/1TE6ZWzNg8cDpvL4Vu0VGOZQLXkQ88Fa59AORzN01Avk/edit](https://docs.google.com/document/d/1TE6ZWzNg8cDpvL4Vu0VGOZQLXkQ88Fa59AORzN01Avk/edit) --> google doc produced by Saren Seeley on how to read fmriprep output with the contribution of Oscar Esteban
- ([Provins et al., 2022](zotero://select/library/items/BEMZKYK7)) --> interpretation of the extended carpet plot in fmriprep and fmriqc + corresponding nuisance regressor

### Quality assessment (QA):

- Focuses on ensuring the research workflow produces data of “sufficient quality” (e.g identifying a structures artifact caused by an environmental condition that can be actioned upon so that **it doesn’t replicate prospectively in future acquisitions).**

### Quality control (QC):

- **Excludes poor-quality data from the dataset** so that they do not continue through the research workflow and potentially bias the results

\--> QA/QC checkpoints are mostly unstandardized and typically involve the screening of the images one by one.

\--> **Raters:** individual researchers that repeatedly screening data

## Methods

- Assessing the unprocessed data using the MRIQC visual reports
- Assess the results with minimal preprocessing using hte fMRIPrep visual reports.

### Assessment of quality aspects and exclusion criteria

- All based on the visual inspection of the individual MRIQCC and fMRIPrep eports, so they are all qualitative.

# Exclusion criteria for unprocessed BOLD data assessed with MRIQC visual reports

**Note:** “The artifact yielding exclusion are pointed using red arrows, while the artifact not yielding exclusion are pointed using green arrows.” ([Provins et al., 2023, p. 1](zotero://select/library/items/KSI3K2X5)) ([pdf](zotero://open-pdf/library/items/WMHQS3TB?page=1))

- **Artifactual structures in the Background**
    
    \--> **Because no BOLD signal originates from the air surrounding the head, the background should not contain visible structures.**
    
    However, signal can spill into the background through several imaging processes:
    
    - Aliasing ghosts (see below)
    - Spillover originating from moving and blinking eyes
    - Bulkhead motion

      -->> **Where to find:**

                        1) **Background noise panel**

                        2) Standard deviation map view

    **\--> What to look for:**

[image]

- **Susceptibility distortion artifacts**
    
    **\-->** **Caused by B0 field non-uniformity**.
    
    - Inserting an object in the scanner perturbs the nominal B0 field, which should be constant all across the FoV
    - Tissue boundaries produce steps of deviation from the nominal B0 field, which are **larger where the air is close to tissues**
    - The signal is slightly diplaced from the sampling grid along the phase encoding axis leading to susceptibility distortions.
    
    **\--> Where to find:**  
    
                                 **On the BOLD average panel**
    
          --> In two different ways
    
    1. **As a signal drop out - that is a region where the signal vanishes**
        
        \-- Signal drop - outs often apper close to the brain - air interfaces
        
        1. Ventromedial prefrontal cortex
        2. Anterior part of the prefrontal cortex
        3. Region next to ear cavities
    2. **As brain distortions**

       **\--> What to do to correct:**  can by corrected by the susceptibility distortion correction implemented in FMRIPrep as long there is as a **corresponding filed map**

                            --> Therefore, susceptibility distortions does not necessarily mean an exclusion criteria

    **\--> What to look for:**

    [image]

-     **Aliasing ghosts**
    
    **\--> A ghost is a type of structured noise that appears as shifted and faintly repeated versions of the main object, usually in hte phase encoding direction.**
    

     --> For several reasons:

                \-- signal instability between pulse cycle repetitions

                \-- the particular strategy of echo-planar imaging to record the k-space during acquisition

         --> Often exacerbated by whithin-volume had motion.

**\--> Where to find:**  

                **1) In the background noise visualisation**

                2) Bold average view

**\--> What to look for:**

[image]

[image]

**Important Tip: Increase the screen’s brightness as low brightness makes this artifact harder to see!**

- **Wrap-around**
    
    **\--> Whenever the object’s dimensions exceed the defined field-of-view (FOV).**
    
    - It is visibe as a piece of the head (usually the skull) being folded over on the opposite extreme of the image
    - Exclude subjects based on the observation of a wrap-around only if the folded region contained or overlapped in the cortex.

**\--> Where to find:**  

                              1) Background noise visualisation --> The clearest

                   2) BOLD average

                              3)  Standard deviation map

**\--> What to look for:**

[image]

**Important Tip: Increase the screen’s brightness as low brightness makes this artifact harder to see!**

- **Assessment of the time series with the carpet plot**
    
    \--> Carpet plot is a tool to **visualise changes in volel intensity** throughout an fMRI scan.  The idea is to **plot voxel time series in close spatial proximity so that the eye notes temporal coincidence.**
    

      -->  Both in MRIQC and fMRIPrep

    **\--> Crown area:** correspond’s to voxels located on a closed band around the brain’s outer edge. As those voxels are outside the brain, we do not expect any signal there, meaning that if some signal is observed, we can interpret it as artifactual.

            **\--> A strongly structured crown region in the carpet plot is a sign that the artifacts are compromising the fmri scanner.**

            Could be due to:

                            1) motion picks

                            2) periodic motion (e.g. respiration)

                            3) coil failure

                            4) drift of unknown source

            \--> Finding temporal patterns similar in gray matter areas and simultaneously in regions of no interest (for instance, cerebrospinal fluid or the crown) indicates the presence of artifacts, typically derived from head motion.

                            If the planned analysis specifies noise regression techniques based on information from these regions of no interest [which is standard and recommended (Ciric et al., 2017)], the risk of removing signals with neural origins is high, and affected scans should be excluded.” ([Provins et al., 2023, p. 5](zotero://select/library/items/KSI3K2X5))

**\--> What to look for:**

               [image]

- **Hyperintensity of single slices**
    
    \--> Several time series to support the interpretation of the carpet
    
    **\--> The slice-wise z-standardized signal average is useful for detecting sudden “spikes” in the average intensity of singel slices of BOLD scans**
    
    - When paired with the motion traces, it is possible to determine whether these spikes are caused by:
        
        - **motion** --> Spikes caused by motion typically **affect several or all slices**
        - or by possible **problems with the scanner** (e.g. white-pixel noise) --> Spikes caused by **white - pixel noise affect only one slice and are generally more acute**
    - White-pixel noise is generally caused by some small pieces of metal in the scan room or a loose screw on the scanner that accumulates energy and then discharges randomly.In the image domain, it manifests as an abrupt signal intensity change in one slice at one time point.
    - **For resting-state data, you discard BOLD scans containing these spikes regardless of their physical origin (motion vs. white-pixel noise) because correlation analyses are likely biased by such peaks. Task data analyses are typically more robust to this particular artifact.**

**\--> What to look for:**

[image]

- **Vertical strikes in the sagittal plane of the standard deviation map**
    
    - The sagittal view of the sd map might show vertical strike patterns that extend hyperintensities through the whole sagittal plan
    - Exclude all images that showcase these patterns

**\--> What to look for:**

[image]

- **Data formatting issues**
    
    \--> Such mistakes result in the brain image not being correctly visualized and preprocessed, with axes either being flipped (e.g. the anterior part of the brain is labeled as posterior) or switched (e.g. axial slices are interpreted as coronal ones).
    

**Examples:**

[image]

**Other important notes**

1. MRIQC --> Visual Reports --> **Bold average:** It gives you the Bold average, so it’s averaging all the volumes together and presenting them as this slices through that average.
    
    **\--> What are you looking for is in the main area of the brain to see a high contrast between grey and white matter**  
    **BUT: Note that these images are not preprossessed so there is no distortion correction! So in an AP image as the one below if you see some smooshing at the front and some extension at the back that’s completely normal** ([“Introduction to MRIQC [TRAIN-05-2022]”, 2022](zotero://select/library/items/GBRPHHIX))
    
    **Example:** (AP image)
    
    [image]
    

    **2\. Standard deviation map:** what is **the spread of the value of all of the voxels over the entire time course**

        e.g. : When you are looking to at the sd of voxels that correspond to the eyes, these have high sd because the are constantly moving so the values are going to have a high spread.

[image]

**\--> But when you are in the brain what you want are low sd values!**

    Also, you do get areas of high sd:

        \- along the edges of the brain (due to slight movement that causes these voxels to have brain or CSF or skull or empty space)  

        \- and in some of the major blood vessels that go through the brain  

        [image]

**3\. Framewise Displacement (FD) [mm]:** the absolute distance after motion that the brain moved from the beginning reference image (but note that no actual motion correction is saved at this point).

\--> 0.2 mm cut -off, you get an idea on how many volumes when beyond this cut-off point, **note** that this is a pretty stringent cut-off score for FD

**Example:**

[image]