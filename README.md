# Matlab-stuff
simple examples of diagnostic and modelling algorithm

Here there would be simple algorithms examples
#Introduction
Automatic detection of process faults requires process expertise to determine the fault symptoms and mathematical algorithms that can classify these symptoms correctly
This repository contains algorithms used to detect valve static friction (stiction), which is a major source of oscillations in control loops. In fact, researches have stated that around 30% of control loops on Canadian paper mills remain oscillating due stiction. However, stiction is frequently undiscovered. In this repo there are three automatic stiction detection algorithms and simulated data of a valve with stiction.

# Algorithms
wrco- The cross-correlation method evaluates the cross-correlation function between the controller output and the controlled variable. The method detects stiction if the resulting cross-correlation function is even, since a symmetrical cross-correlation function is the result of non-stiction disturbances. This method can only be implemented on self-regulating loops.

