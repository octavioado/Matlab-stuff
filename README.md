# Matlab-stuff
simple examples of diagnostic and modelling algorithm

Here there would be simple algorithms examples
#Introduction
Automatic detection of process faults requires process expertise to determine the fault symptoms and mathematical algorithms that can classify these symptoms correctly
This repository contains algorithms used to detect valve static friction (stiction), which is a major source of oscillations in control loops. In fact, researches have stated that around 30% of control loops on Canadian paper mills remain oscillating due stiction. However, stiction is frequently undiscovered. In this repo there are three automatic stiction detection algorithms and simulated data of a valve with stiction.

# Algorithms
wrco- The cross-correlation method evaluates the cross-correlation function between the controller output and the controlled variable. The method detects stiction if the resulting cross-correlation function is even, since a symmetrical cross-correlation function is the result of non-stiction disturbances. This method can only be implemented on self-regulating loops.

aret-The area ratio method proposed  assumes that a control loop with a valve having stiction generates a sail shaped oscillations in the controlled signal. Alternatively, other oscillation sources produce the symmetric oscillation patterns. The method analyses the symmetry of each half period of the oscillation by dividing each half-period by its maxima and calculating the area of each division. Stiction detection occurs if the area of the figure before the peak is significantly larger than the area of the region after the peak in most oscillation half-periods. The method is designed for self-regulating loops.

#Data
SJeq- simulation data from a valve with an exponential response with stiction. the data set contains three variables op, mv and error
op- controller output signal
mv- manipulated variable signal (valve opening)
error- process error signal (o deviation from the valve setpoint)
