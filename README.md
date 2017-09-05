# Neuroscience
## A mess of code for various neuroscience endeavors.

### Classes
A large part of my focus during college was using computation to improve the biological sciences through data processing and computational modeling.
* Computational Neuroscience - focused on modeling neurons, neuronal circuit, and metaphysical behavior of the brain.
* Scientific Data Processing - Class about information processing through the lens of computer science. It touched on machine learning and had an emphasis on image processing.
* Data Analysis - Class about information processing through the lens of neuroscience using computational techniques. It taugh statistical testing, time series & audio processing, image processing, regressions and machine learning in high dimensional datasets.

### Thesis
My thesis work was published at the Journal of Neuroscience here http://jn.physiology.org/content/118/2/874.long.
For further information please contact me! You can find my contact info at www.iankchristie.com

#### Introduction & Motivation
Direction Selectivity is a type of visual selectivity that will cause Direction Selective neurons to fire preferentially to a given 'prefered direction' than to it's opposite, 'null direction'. This type of selectivity does not exist in ferrets & monkeys at birth, but instead requires experience to form the complicated neuronal networks it arises from. Understanding how experience plays a role in development for this model has implications for the development of neuronal networks in general.

To make the simulations as realistic as possible we wanted to include rate based cortical columns, inhibitory columns, and suppression of null direction inhibition. Further information can be found here: http://cns-classes.bu.edu/cn510/Papers/Theoretical%20Neuroscience%20Computational%20and%20Mathematical%20Modeling%20of%20Neural%20Systems%20-%20%20Peter%20Dayan,%20L.%20F.%20Abbott.pdf

#### Methodology
Our question was: can we come up with a model of cortical columns that can go from a non-directional-selective state to a selective state with a known form of neuronal plasticity?

To solve this problem we imagined that each model was a point in high dimensional space were each axis was a parameter to the model. With a given input, we could simulate the response of the model and classify. We could then classify regions of this high dimensional space. We were able to identify non-selective regions and selective regions. From a high level this would tell us what parameters had to be plastic in order to transition between regions in the space.

Then we could subject the model to training to plasticity rules we created to see if the models successfully transitioned from the states of interest.

#### Procedure
Computational modeling was done in MATLAB and performed on the Brandeis Computer Cluster. Sets of simulations ran on 128 cores for days at a time, even after clever optimizations.

#### Results (Warning: High amounts of Neurospeak)
A Hebbian plasticity rule combined with simulated experience with stimuli weakened strong cross-connections across cortical columns, allowing the individual columns to respond selectively to their biased inputs. In a model that included both excitatory and inhibitory neurons in each column, an additional means of obtaining selectivity through the cortical circuit was uncovered: cross-column suppression of inhibition-stabilized networks. When each column operated as an inhibition-stabilized network, cross-column excitation onto inhibitory neurons forced competition between the columns but in a manner that did not involve strong null-direction inhibition, consistent with experimental measurements of direction selectivity in visual cortex. Experimental predictions of these possible contributions of cortical circuits were found as well.
