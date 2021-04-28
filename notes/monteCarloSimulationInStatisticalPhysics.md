# Monte Carlo Simulation in Statistical Physics: an introduction (fifth edition) 
*Kurt Binder* 

-------------------------------------------------------------------------------

# Chapter 1: Introduction
Value of simulation: 
- Information provided by experiment is **never precisely known**. Can you tell the different between some intrinsic property and some unknown experimental impurity or error? 
- Information from analytic calculations is exact only in **rare** cases. Uncontrolled approximations are usually required to get to the real world. 
- You can use simulation to check the validity of the approximations 
- You can use simulation to check theory precisely with little uncertainty.


This textbook restricts itself to **Monte Carlo simulations only**. 

# Chapter 2: Theoretical Foundations of the Monte Carlo Method and Its Applications in Statistical Physics
## 2.1 Simple Sampling Versus Importance Sampling 
### Models 
-Typical problem: compute the "average" macroscopic observables for a system with a known Hamiltonian
- Example: **Magnetic Systems** ferromagnet with strong uniaxial anisotropy (i.e. spins are aligned mostly with $\pm z$ axis), then we can use the **Ising Model** with $N$ spins $S_i$ interacting via 
\begin{equation}
    \mathcal{H}_{Ising} := -J\sum_{\langle i, j \rangle}S_iS_j - H\sum_{i}S_i, \qquad S=\pm1
\end{equation}
where $\langle i,j \rangle$ refers to the set of all neighbor pairs (we only consider nearest neighbor interactions). The first term is the interaction between two neighboring spins. Here we assume a constant interaction energy. The second term is the Zeeman energy of the system due to spins in a magnetic field with strength $H$.

If we allow the spin to instead live in a plane, we get the $\mathcal{H}_{XY}$ model. In the fully isotropic case, we are required to consider the full spin vectors $\vec{S}_i$ with an interaction governed by $\vec{S}_i\cdot\vec{S}_j$. Such a model is known as the $\mathcal{H}_{Heisenberg}$ Heisenberg model.

Further, we can consider more general cases with spin numbers $S \neq 1/2$ if we so choose. 


**Goal**: computing average macroscopic properties, e.g. average energy per lattice site:
\begin{equation}
    E = \langle\mathcal{H}\rangle_T / N, \qquad \vec{M} = \langle \sum_i \vec{S}_i \rangle_T / N
\end{equation}
where $\langle \mathcal \rangle_T$ denotes the ensemble average of $\mathcal{H}$ (in this case, the canonical ensemble), e.g. 
\begin{align}
    \langle A \rangle_T &:= \frac{1}{Z}\int A \exp(-\beta\mathcal{H})d\vec{r} \\ 
    Z &:= \int \exp(-\beta\mathcal{H})d\vec{r}
\end{align}

**Problem** we are not interested in such detailed information as $Z$ nor do we wish to carry out these integrations involved. *Is this really necessary?*

### Simple Sampling
Idea: instead of integrating over all of phase, let's choose a representative subset and approximate the thermal averages via a sum: 
\begin{equation}
    \bar{A} = \frac{\sum_i^N A_i \exp(-\beta \mathcal{H}_i)}{\sum_j^N \exp(-\beta\mathcal{H}_j)}
\end{equation}
<mark>However, it makes no sense to sample the points in phase space evenly. Better would be to use a *uniform* distribution of *random points*. </mark> <-- we probably want to explain this better


### Random Walks and Self-Avoiding Walks
consider a simple lattice and vectors $\vec{v}(k)$ which connect each site to its nearest neighbors.To generate unrestricted random walks of $N$ steps we perform the following procedure:
1. set $\vec{r}=\vec{0}$ and $k=0$. 
2. Choose a random integer $k_i$ from $\{1,2,3,4\}$
3. Update $\vec{r}_{i+1} = \vec{r}_i + \vec{v}(k_i)$
4. If $i==N$ end routine 
5. Go back to step (2)
This is a useful model for some processes but **not for polymer folding** because the random walk can self intersect. To fix this we can update step 2 to read 
2. select a random integer $k_i$ from $\{1, 2, 3, 4 \}/\{k_{i-1}\}$
This makes it so that the random walk never goes immediately backwards. 

To make it so that there are no intersections, we can check the nearest-neighbors to see if we have already visited a site and only select from the subset of viable points.
