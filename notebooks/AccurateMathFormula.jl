### A Pluto.jl notebook ###
# v0.19.23

using Markdown
using InteractiveUtils

# ╔═╡ c3f5e2c1-d31f-4175-a66f-764afe0eb21f
md"""
# Choosing most accurate mathematical formula: $a^2-b^2$ or $(a+b)(a-b)$ 

Let r be the radius of a sphere. The area of the sphere is calculated using:  
$E = 4πr^2$
We will alter the radius by some $\mathrm{d}r$ and we will calculate the change of the sphere's area, let it be $\mathrm{d}E$.
"""

# ╔═╡ 20a48888-f5bb-4107-8cd6-e5fe1bb2aa9e
md"""
### First way
We calculate the difference between the two areas:

$$\mathrm{d}E = 4\pi(r+\mathrm{d}r)^2 - 4\pi r^2.$$

### Second way
We use the identity $a^2-b^2 = (a+b)(a-b)$:

$$\mathrm{d}E = 4\pi \mathrm{d}r(2r+ \mathrm{d}r)$$
"""

# ╔═╡ 1101e156-176d-4def-968d-dd538f079bb9
md"""
#### Our course of action
1. Selection of $\mathrm{d}r$.

2. Computation of the exact value of $\mathrm{d}E$, using the ``BigFloat`` datatype provided by **Julia** (it doesn't matter which formula we will use, since the difference in the result would be negligible).

3. Conversion of $\mathrm{d}r$ back into the usual ``Float64`` datatype and calculation of $\mathrm{d}E$ using the two aforemetnioned formulas.

4. Computation of the following relative errors:

$$rel_1 = \bigg| \cfrac{\mathrm{d}E - \mathrm{d}E_1}{\mathrm{d}E} \bigg|$$
$$rel_2 = \bigg| \cfrac{\mathrm{d}E - \mathrm{d}E_2}{\mathrm{d}E} \bigg|$$
"""

# ╔═╡ b7766f91-e437-4ef7-8097-b216a79286a9
md"""Our code should look like this:"""

# ╔═╡ f13a2d69-875e-423f-8571-759478041a6d
function sphere_area(n)
    r = 6367 # Earth's radius in kilometers
    err1 = err2 = 0
    count1 = count2 = 0
    for i in 1:n
        dr = rand(BigFloat)
        dE = Float64(4*pi*(r+dr)^2 - 4*pi*r^2)
#print(dE)
        dr = Float64(dr)
        dE1 = 4*pi*(r+dr)^2 - 4*pi*r^2
#print(dE1)
        dE2 = 4*pi*dr*(2*r+dr)
#print(dE2)
        rel1 = abs(dE-dE1)/dE
        rel2 = abs(dE-dE2)/dE
        if rel1 < rel2
            count1 += 1
		elseif rel2 < rel1
            count2 += 1
        end
    end
    return [count1*100/n, count2*100/n]
end

# ╔═╡ afd6a481-4d64-4514-8332-fa005cea36b6
sphere_area(10000)

# ╔═╡ 70531a35-6aed-497e-8f25-07cc139b09de
md"""
Let $P_1$ be the percentage that the 1st formula is more accurate, and $P_2$ be the percentage that the 2nd formula is more accurate.
"""

# ╔═╡ c3fe3da2-2162-49dc-b15e-fec210a3c2e2
html"""<table>
  <tr>
    <th>n</th>
    <th>P1</th>
    <th>P2</th>
  </tr>
  <tr>
    <td align="right">10,000</td>
    <td>38.53%</td>
    <td>61.47%</td>
  </tr>
  <tr>
    <td align="right">100,000</td>
    <td>37.99%</td>
    <td>61.99%</td>
  </tr>
  <tr>
    <td align="right">1,000,000</td>
    <td>38.07%</td>
    <td>61.99%</td>
  </tr>
  <tr>
    <td align="right">10,000,000</td>
    <td>38.10%</td>
    <td>61.88%</td>
  </tr>
  <tr>
    <td align="right">100,000,000</td>
    <td>38.10%</td>
    <td>61.88%</td>
  </tr>
</table>
"""

# ╔═╡ 4339158b-5c80-4aca-ae81-afcbd194f279
md"""
## Conclusion

For random  $dr \in [0,1]$  we observe that the formula  $(a+b)(a-b)$
is much more accurate than $a^2-b^2$.
"""

# ╔═╡ d24f1657-7347-489d-ba84-8889546cfcb5
md"""
###  Proof
Let $a,b$ be machine numbers with $a\approx b$. Then 

$$fl(a) = a \quad \wedge \quad fl(b)=b.$$

Calculating with the first way, we have: 

$$fl (fl(a)\cdot fl(a)) = fl(a\cdot a) = a^2(1+\epsilon_1)$$

$$fl (fl(b)\cdot fl(b)) = fl(b\cdot b) = b^2(1+\epsilon_2),$$

where $|\epsilon_1|, |\epsilon_2| \leq u$.

Therefore,

$$z_1 = fl \bigr( fl(fl(a)\cdot fl(a)) - fl(fl(b)\cdot fl(b)) \bigl) = \bigr( a^2(1+\epsilon_1) - b^2(1+\epsilon_2) \bigl) (1+\epsilon_3) =$$

$$= a^2(1+\epsilon_1)(1+\epsilon_3)-b^2(1+\epsilon_2)(1+\epsilon_3),$$

where $|\epsilon_3|\leq u$.

From known properties we have:

$$z_1 = a^2(1+\delta_1)^2-b^2(1+\delta_2)^2,$$

where $|\delta_1|, |\delta_2| \leq u$.

Since $\delta_i^2 << 2\delta_i, \ i=1, 2:$

$$z_1 \approx a^2(1+2\delta_1)-b^2(1+2\delta_2).$$

We calculate the relative error:

$$Rel_1 = \bigg|\cfrac{z-(a^2-b^2)}{a^2-b^2}\bigg|= 2 \bigg|\cfrac{a^2\delta_1-b^2\delta_2}{a^2-b^2}\bigg| \leq 2\bigg|\cfrac{a^2+b^2}{a^2-b^2}\bigg|,$$

which is inceased as $a\approx b$.

We will now use the $a^2-b^2 = (a-b)(a+b)$.

$$fl(fl(a)-fl(b))=(a-b)(1+\epsilon_1)$$
$$fl(fl(a)+fl(b))=(a+b)(1+\epsilon_2),$$

where $|\epsilon_1|, |\epsilon_2| \leq u$.

Then :

$$z_2 = fl \bigl( fl(fl(a)-fl(b))\cdot fl(fl(a)+fl(b))  \bigl) = fl \bigr( (a-b)(a+b)(1+\epsilon_1)(1+\epsilon_2) \bigl) = $$

$$= (a-b)(a+b)(1+\epsilon_1)(1+epsilon_2)(1+\epsilon_3) = (a^2-b^2)(1+\epsilon)^3,$$

where $|\epsilon| \leq u$.

Therefore, since $\epsilon^3 << 3\epsilon^2 << 3\epsilon,$ the relative error is:

$$Rel_2 = \bigg| \cfrac{z-(a^2-b^2)}{a^2-b^2} \bigg| = |\epsilon^3+3\epsilon^2 + 3\epsilon| \approx 3|\epsilon| \leq 3u,$$

which is a negligible error.
"""

# ╔═╡ Cell order:
# ╟─c3f5e2c1-d31f-4175-a66f-764afe0eb21f
# ╟─20a48888-f5bb-4107-8cd6-e5fe1bb2aa9e
# ╟─1101e156-176d-4def-968d-dd538f079bb9
# ╟─b7766f91-e437-4ef7-8097-b216a79286a9
# ╠═f13a2d69-875e-423f-8571-759478041a6d
# ╠═afd6a481-4d64-4514-8332-fa005cea36b6
# ╟─70531a35-6aed-497e-8f25-07cc139b09de
# ╟─c3fe3da2-2162-49dc-b15e-fec210a3c2e2
# ╟─4339158b-5c80-4aca-ae81-afcbd194f279
# ╟─d24f1657-7347-489d-ba84-8889546cfcb5
