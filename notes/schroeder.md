# 8.2 The Ising Model of a Ferromagnet
## Ferromagnetic Materials
*ideal paramagnet*: each magnetic dipole responds only to the external field. Dipoles have no inherent tendency to align (parallel or antiparallel) to their neighbors.  

*ideal ferromagnet*: Neighboring dipoles align themselves parallel to each other in the absence of an external field.  

*ideal anti-ferromagnet*: Neighboring dipoles align themselves antiparallel to each other in the absence of an external field.  

Raising the temperature of a ferromagnet causes random fluctuations of the dipoles that reduce the total magnetization. We identify the critical temperature beyond which the magnetization becomes zero as the **Curie Temperature**. 
- $T_c$ for iron is $~1043$ K

Magnets have a tendency to divide themselves into **domains** with billions of dipoles that are all aligned. Neighboring domains have a tendency to have opposite magnetization, so you may not notice the magnetic field of a ferromagnet below the Curie temperature.

## The Ising Model
- assume material has *one* preferred axis of magnetization, say the $+z$ axis. Each dipole can only be parallel or antiparallel to this axis.
- assume that only neighboring dipoles interact with each other. 
- due to quantum mechanical effects (i.e. quantization of spin), this model will not be accurate at low temperatures where the quantum effects are most important.
- See: **History of the Lenz-Ising Model, Stephen G. Brush**  

Let $N$ be the total number of dipoles. Let $s_i$ be the current state of the $i^{th}$ dipole, i.e. $s_i = \pm 1$. The energy of interaction for two dipoles will be $-\epsilon$ if the dipoles are parallel, and $\epsilon$ if they are antiparallel. Thus, we have $U_{ij} = -\epsilon s_i s_j$ with the total energy of the system given by 
\begin{equation}
    U = -\epsilon\sum_{\langle i, j \rangle} s_i s_j
\end{equation}
where $\langle i, j \rangle$ denotes all pairs of neighboring dipoles.

To investigate the thermodynamics of this model, we need to determine the partition function (canonical) 
\begin{equation}
    Z = \sum_s e^{-\beta E_s}
\end{equation}
if we have $N$ dipoles, then there are $2^N$ possible arrangements (a number too large for us to consider in most cases). 

## Exact solution in one dimension
In one dimension, each dipole has only two nearest neighbors, and thus the total energy can be written as 
\begin{equation}
    U = -\epsilon(s_1s_2 + s_2s_3 + ... s_{N-1}s_N)
\end{equation}
further, we see that 
\begin{equation}
Z = \sum_{s_1}\sum_{s_2}...\sum_{s_N}e^{\beta\epsilon s_1s_2}e^{\beta\epsilon s_2s_3}...e^{\beta\epsilon s_{N-1}s_N}
\end{equation}
but upon examination, we find that 
\begin{equation}
\sum_{s_i}e^{\beta\epsilon s_i s_{i+1}} = e^{\beta \epsilon}  + e^{-\beta\epsilon} = 2\cosh(\beta\epsilon)
\end{equation}
as $s_is_i+1 = \pm 1$. Thus, 
\begin{equation}
Z = (2\cosh(\beta\epsilon))^N
\end{equation}
and therefore 
\begin{equation}
\langle U \rangle = -\partial_\beta \ln Z = -N\epsilon\tanh\beta\epsilon
\end{equation}


## Mean Field Approximation
A crude approximation that can "solve" Ising model in any dimensionality.  

Consider a single dipole, $i$, with alignment $s_i=\pm 1$. Let $n$ be the number of nearest neighbors, i.e. 
- $n=2$ in one dimension
- $n=4$ in two dimensions (square lattice) 
- $n=6$ in three dimensions (simple cubic lattice) 
- $n=8$ in three dimensions (body-centered cubic lattice) 
- $n=12$ in three dimensions (face-centered cubic lattice)
If we imagine the neighbors as being frozen in, then the interaction energy will be 
\begin{equation}
    U_i = \mp\epsilon\sum_{neighbors}s_{neighbors} = \mp\epsilon n\bar{s}
\end{equation}
where $\bar{s}$ is the average alignment of the neighbors.
Therefore, the partition function for the $i^{th}$ dipole is 
\begin{equation}
Z_i = e^{\beta\epsilon n \bar{s}}+e^{-\beta\epsilon n \bar{s}} = 2\cosh(\beta\epsilon n\bar{s})
\end{equation}
The average value for $s_i$ is therefore 
\begin{equation}
\langle s_i \rangle = \frac{1}{Z}\left  (1)e^{\beta\epsilon n \bar{s}}+ (-1)e^{-\beta\epsilon n \bar{s}}  \right) = \tanh(\beta\epsilon n \bar{s})
\end{equation}  

In the mean field approximation we assume $\langle s_i \rangle = \bar{s}$. Therefore, 
$\begin{equation}
    \bar{s} = \tanh(\beta\epsilon n \bar{s})
\end{equation}


## Monte Carlo Simulation
Consider 2-dimensional square lattice Ising model with $N=100$ dipoles.  

**Problem**: The fastest computer could not compute the probabilities of *all* of the ($2^N$) states.  
**Solution**: We don't need to consider all of the states... Most of them are *very unlikely*

Idea 1: Randomly sample states, compute Boltzmann factors, use sample to approximate true system.  
This method is okay for some systems, but is *bad* for the Ising most of the states are relatively uninteresting and improbable. 

Idea 2: Use Boltzmann factors as a guide for randomly selecting states. 

**Metropolis Algorithm**
1. Start with any state whatsoever
2. Chose a dipole at random and consider flipping it
3. Compute the energy difference $\Delta U$ between the flipped and unflipped state. 
4. If $\Delta U\leq 0$, flip the dipole (we are interested in low-energy equilibria) i.e. the chance of this happening is $1/N$ $=$ to chance of selecting the $i^{th}$ dipole
5. If $\Delta U > 0$, decide at random whether to flip the dipole with a probability of $e^{-\beta\Delta U}$.
6. Repeat process until each dipole has had many chances to flip (say 100 each)  

This technique is also called **Monte Carlo with Importance Sampling**

This method forces low energy states to be more likely. Suppose we have two states $U_1, U_2$ with $U_1 \leq U_2$. Then based upon our algorithm, we have 
\begin{equation}
    \frac{\mathcal{P}(1\to 2)}{\mathcal{P}(2\to 1)} = \frac{(1/N)\exp(-\beta\Delta U)}{1/N} = \exp(-\beta\Delta U)
\end{equation}
This ratio of probabilities is exactly the Boltzmann ratio we want! Algorithms that obey this rule are said to obey **Detailed Balance** In other words, if $W_{12}$ is the rate of transition from state 1 to state 2 (and similarly for $W_{21}$, then 
\begin{equation}
    \frac{\mathcal{P}_1}{\mathcal{P}_2} = \frac{W_{21}}{W_{12}}
\end{equation}
In words: *The ratio of transition rates is equal to the inverse of the ratio of probabilities for each state*

**Detailed balance will only apply once we've sampled many states.**

**Note: Such 'simulations' do not actually simulate the time dependence of the system.**
