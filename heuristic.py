from __future__ import annotations

import logging
from typing import Optional

from heudiconv.utils import SeqInfo

lgr = logging.getLogger("heudiconv")


def create_key(
    template: Optional[str],
    outtype: tuple[str, ...] = ("nii.gz",),
    annotation_classes: None = None,
) -> tuple[str, tuple[str, ...], None]:
    if template is None or not template:
        raise ValueError("Template must be a valid format string")
    return (template, outtype, annotation_classes)


def infotodict(
    seqinfo: list[SeqInfo],
) -> dict[tuple[str, tuple[str, ...], None], list[str]]:
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    data = create_key("run{item:03d}")

    # Anatomical images
    # Structural scans (anat specification): MUST end with "T1w" or "T2w" or "FLAIR" or "T1map"...
    # list: https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/01-magnetic-resonance-imaging-data.html#anatomy-imaging-data
    t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')
    
    # field maps (fmap specification): the file name must end with "magnitude" or "phasediff" and include the {subject}
    # specifications: https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/01-magnetic-resonance-imaging-data.html#fieldmap-data
    fmap_magn = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_magnitude')
    fmap_phase = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_phasediff')

    # Functional images
    # Tasks, including movies (func specification): MUST contain "task-" in the name + "bold" or "sbref" or "cbv" or "phase" at the end
    # list: https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/01-magnetic-resonance-imaging-data.html#task-including-resting-state-imaging-data
    func_PINES = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-pines_bold')
    func_PINES_sbref = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-pines_sbref')

    info: dict[tuple[str, tuple[str, ...], None], list[str]] = {data: [],
                                                                func_PINES: [],
                                                                func_PINES_sbref: [],
                                                                fmap_magn: [],
                                                                fmap_phase: [],
                                                                t1w: []
                                                                }

    for s in seqinfo:
        """
        The namedtuple `s` contains the following fields:

        * total_files_till_now
        * example_dcm_file
        * series_id
        * dcm_dir_name
        * unspecified2
        * unspecified3
        * dim1
        * dim2
        * dim3
        * dim4
        * TR
        * TE
        * protocol_name
        * is_motion_corrected
        * is_derived
        * patient_id
        * study_description
        * referring_physician_name
        * series_description
        * image_type
        """

        
        if ("pines" in s.protocol_name) and (s.dim4 == 1) :
            info[func_PINES_sbref].append(s.series_id)
        if ("pines" in s.protocol_name) and (s.dim4 > 100 ) :
            info[func_PINES].append(s.series_id)
        if ("fmap" in s.protocol_name) and (s.dim3 == 120) :
            info[fmap_magn].append(s.series_id)
        if ("fmap" in s.protocol_name) and (s.dim3 == 60) :
            info[fmap_phase].append(s.series_id)
        if ("T1w" in s.protocol_name) :
            info[t1w].append(s.series_id)



        #info[data].append(s.series_id)
    return info
