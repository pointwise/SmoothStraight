#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

#
# N Chettle (S&C Thermofluids)
# nick.chettle@thermofluids.co.uk
# 
# This sample script is not supported by S&C Thermofluids
#  
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

###############################################################################
##
## Smooth and Straighten.glf
##
## Script to smooth and straighten connectors
##
###############################################################################

package require PWI_Glyph 2

#pw::Script loadTk


############################################################################
# pickCons: select connectors
############################################################################
proc pickCons { } {
  set conMask [pw::Display createSelectionMask -requireConnector {} \
    -blockConnector {Pole}]
  pw::Display selectEntities -selectionmask $conMask \
    -description "Select connector(s) to smooth and straighten" results

  set cons $results(Connectors)

  if {[llength $cons] == 0} {
    exit
  }

  return $cons
}

set cons [pickCons]


############################################################################
#smooth the selected connectors
############################################################################

foreach con $cons {
set smooth_mode [pw::Application begin Modify $con]
$con smoothC1 -tolerance 100000
$smooth_mode end
unset smooth_mode
pw::Application markUndoLevel {Smooth}

############################################################################
#and then straighten them using the Catmull-Rom
############################################################################

set straight_mode [pw::Application begin Modify $con]
set seg [$con getSegment -copy 1]
$seg setSlope CatmullRom
$con replaceAllSegments $seg
unset seg
$straight_mode end
unset straight_mode
pw::Application markUndoLevel {Edit Connector}

}

#############################################################################
#
# This file is licensed under the Cadence Public License Version 1.0 (the
# "License"), a copy of which is found in the included file named "LICENSE",
# and is distributed "AS IS." TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
# LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO
# ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE.
# Please see the License for the full text of applicable terms.
#
#############################################################################