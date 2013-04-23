#
# N Chettle (S&C Thermofluids)
# nick.chettle@thermofluids.co.uk
# 
# This sample script is not supported by Pointwise Inc or S&C Thermofluids
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

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE AND S&C THERMOFLUIDS 
# DISCLAIM ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED 
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE OR S&C THERMOFLUIDS BE LIABLE TO ANY PARTY 
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE 
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE AND S&C THERMOFLUIDS HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE 
# FAULT OR NEGLIGENCE OF POINTWISE OR S&C THERMOFLUIDS.
#