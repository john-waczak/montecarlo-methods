using Images
using ImageView
using ImageIO
using Plots
using JLD
using Random
# using StaticArrays


Random.seed!(42) # seed the random number generator for reproducability


const N = 500 # size of side
T = 2.27 # Units: ϵ/k, i.e. we set ϵ=1
const NUMITERS = 100*N^2  # 100 iterations per pixel 
s = zeros(Float64, (N,N))


const init_rand = true
if init_rand
    s =   rand((-1.0, 1.0), (N, N))
else
    s =  ones(N, N)
end


function ΔU(i, j)
    if i == 1
        top = s[N, j]
    else
        top = s[i-1, j]
    end

    if i == N
        bottom = s[1,j]
    else
        bottom = s[i+1, j]
    end

    if j == 1
        left = s[i, N]
    else
        left = s[i, j-1]
    end

    if j == N
        right = s[i, 1]
    else
        right = s[i, j+1]
    end

    return 2*s[i,j]*(top+bottom+left+right)
end




# Tests:
# println(ΔU(1, 1))
# println(ΔU(N,N))
# println(ΔU(2, 2))

#canvas = imshow(s)["gui"]["canvas"]
for iter∈1:NUMITERS
    i = rand(1:N)
    j = rand(1:N)

    Ediff = ΔU(i,j)
    if Ediff <= 0
        s[i,j] = -s[i,j]
    else
        if rand() < exp(-Ediff/T)
            s[i,j] = -s[i,j]
        end
    end

    # if iter%1000==0
    #     println("$(iter)  $(Ediff)")
    #     imshow(canvas, s)
    #     sleep(0.001)
    # end

end

save("./data/ising_N-$(N)_T-$(T).jld", "data", s)

idx_mask = (s .< 0.0)
img = s
img[idx_mask] .= 0.0

save("./figures/ising_N-$(N)_T-$(T).eps", img)

