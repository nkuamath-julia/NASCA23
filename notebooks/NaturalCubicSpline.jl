### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ adc6a9ca-1909-11ee-10a2-51fed6f566e8
begin
	using Random, PlutoUI,LinearAlgebra, HypertextLiteral, Polynomials, Plots, SpecialMatrices
	plotly()
end

# ╔═╡ cfbcfd60-8b67-4ffc-9afb-fadf358241bd
TableOfContents(title="📚 Table of Contents", aside=true)

# ╔═╡ e2bdfd0e-56f6-42d0-98f7-8291fe573708
md"""
# Natural Cubic Spline

## Main idea

Let $f(x)$ be a function and $[a,b]$ an interval.

Choose $n+1$ points, such that

$$
a\equiv x_0<x_1<x_2<\cdots <x_n\equiv b$$

and compute the values

$$
y_i=f(x_i), \quad i=0,1,\ldots,n.$$

On every interval 

$$[x_{i-1},x_i], i=1,2,\ldots n$$

the function $f$ is approximated by cubic polynomial $s_i$.
Therefore, on the entire interval $[a,b]$ function $f$ is approximated by the function

$$
s(x)=s_i(x), \quad x\in[x_{i-1},x_i],\quad i=1,\ldots,n.$$


We require that $s(x)$

- is **continous**,
- **first derivative**,$s'(x)$, is also **continious**, 
- **second derivative**,$s''(x)$, is also **continious**, 

"""

# ╔═╡ a23a9d2a-a7a9-4abf-8e85-a7b28505b3d0
md"""
## Construction of natural cubic spline
"""

# ╔═╡ 5fb34831-1d13-44a3-88ba-ab86176c30b4
md"""
#### Claim: If $z_i=s''(x_i), i=0,1,\ldots ,n$ are known, then $s\,$ can be computed
"""

# ╔═╡ 167662f5-23ba-46a2-91fc-a726f8f6efda
md"""
Indeed, $s_i''(x), x\in [x_i,x_{i+1}], i=0,1,\ldots,n-1$ is a linear polynomial which satisfies 

$$s_i''(x_i)=z_i, \ s_i''(x_{i+1})=z_{i+1}.$$

The linear spline is simply expressed as: 

$$s_i''(x)= z_{i}\cfrac{x-x_{i+1}}{x_i-x_{i+1}}+z_{i+1}\cfrac{x-x_i}{x_{i+1}-x_i},\  x_i \leq x \leq x_{i+1}.\text{(Why?)}$$

If we define $h_i=x_{i+1}-x_i, i=0,1, \ldots n-1$, we get:

$$s_i''(x)= \cfrac{z_{i+1}}{hi}(x-x_i)+\cfrac{z_i}{h_i}(x_{i+1}-x),\  x_i \leq x \leq x_{i+1}.$$

By intergrating twice, we arrive at:

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3+\cfrac{z_i}{6h_i}(x_{i+1}-x)^3+ 
	C_i(x-x_i)+D_i(x_{i+1}-x), x_i \leq x \leq x_{i+1},  i=0,1, \ldots, n-1
	,\  x_i \leq x \leq x_{i+1}.$$
"""

# ╔═╡ 6454e89d-afbb-469a-9b17-71730fa982dc
hint(text,heading) = Markdown.MD(Markdown.Admonition("hint",  "$heading", [text]));

# ╔═╡ 69cf4499-1eb0-461f-bf95-6759c62b12b5
hint(md"""
$$\begin{aligned}
s_i(x_{i-1})&=f(x_{i-1}), \quad &i=1,\ldots,n, \\
s_i(x_{i})&=f(x_{i}) \quad &i=1,\ldots, n,\\
s'_i(x_i)&=s'_{i+1}(x_i), \quad &i=1,\ldots,n-1, \\
s''_i(x_i)&=s''_{i+1}(x_i), \quad &i=1,\ldots,n-1,
\end{aligned}$$

which is a system of $4n-2$ equations and $4n$ unknowns (each of $n$ cubic polynomials has 4 coefficients).	
""", md"""Equations resulting from continuity of s,s',s''""")

# ╔═╡ 57b666b8-a154-4cd4-8b4c-dceac7f21d03
md"""
### Algebra behind construction of natural cubic spline

#### Basic Steps 

1. Intergrate twice and try bringing $s_i(x)$ in the format:

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + A_ix+B_i.$$

2. Write $A_ix+B_i$ as $C_i(x-x_i)+D_i(x_{i+1}-x)$ by solving a system
#### A deeper dive into those steps 🤿🛁

##### The first integration of $s''$
###### 💡Integrate $s_i''(x)$ once to get to:

$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2)+ C, \text{for some $C\in \mathbb{R}$}.$$
"""

# ╔═╡ 38201ff6-817f-4fb9-b36b-268289ed820c
hint(md"""
$$s_i''(x)= \cfrac{z_{i+1}}{hi}(x-x_i)+\cfrac{z_i}{h_i}(x_{i+1}-x)\Rightarrow$$

$$\int s_i''(x)\mathrm{d}x=\int \cfrac{z_{i+1}}{hi}(x-x_i) \mathrm{d}x + \int \cfrac{z_i}{h_i}(x_{i+1}-x)\mathrm{d}x\Rightarrow$$

$$s_i'(x)= \cfrac{z_{i+1}}{hi}(\cfrac{x^2}{2}-x_ix)  +  \cfrac{z_i}{h_i}(x_{i+1}x-\cfrac{x^2}{2})+ C, \text{for some $C\in \mathbb{R}$}.$$ 
""", md"""First integration of s''""")

# ╔═╡ 8c7e0bb9-7ccc-4337-be6d-3f0d97d39100
md"""
###### 💡Complete perfect squares and fine tune coefficients to get to:

$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix+x_i^2)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2-x_{i+1}^2) +C', \text{for some $C'\in \mathbb{R}$}.$$
"""

# ╔═╡ b563e3a0-aae7-4046-b531-5ff2c9c71912
hint(md"""

$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2)+ C.$$ 

In order to complete perfect squares, add and subtract $x_i^2$ and $x_{i+1}^2$ from the 1st and 2nd term of $s_i'(x)$:

$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix+x_i^2-x_i^2)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2+x_{i+1}^2-x_{i+1}^2)+ C \Rightarrow$$ 


$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix+x_i^2)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2-x_{i+1}^2) - \cfrac{z_{i+1}}{2hi}x_i^2 +  \cfrac{z_i}{2h_i}x_{i+1}^2 +C.$$ 

If we define 

$$C' = - \cfrac{z_{i+1}}{2hi}x_i^2  + \cfrac{z_i}{2h_i}x_{i+1}^2 +C,$$

then,

$$s_i'(x)= \cfrac{z_{i+1}}{2hi}(x^2-2x_ix+x_i^2)  +  \cfrac{z_i}{2h_i}(2x_{i+1}x-x^2-x_{i+1}^2) +C', \text{for some $C'\in \mathbb{R}$}.$$ 
""","Fine tuning coefficients of first integration of s''")

# ╔═╡ 78b533d8-1737-4863-a393-907900e108ee
md"""
##### The second integration of $s''$

###### 💡Integrate $s_i'(x)$ to get to:

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x^3-3x_ix^2+3x_i^2x)  +  \cfrac{z_i}{6h_i}(3x_{i+1}x^2-x^3-3x_{i+1}^2x)+ C'x+D', \text{for some $C',D'\in \mathbb{R}$}.$$
"""

# ╔═╡ 07d1b6e3-a0f8-4cb8-9b2d-5643e14f6fce
hint(md"""
By intergrating the expression of $s_i'(x)$ derived above,

$$\int s_i'(x)= \cfrac{z_{i+1}}{2hi}\int(x^2-2x_ix+x_i^2) \mathrm{d}x +  \cfrac{z_i}{2h_i}\int (2x_{i+1}x-x^2-x_{i+1}^2)\mathrm{d}x + \int C'\mathrm{d}x\Rightarrow$$


$$s_i(x)= \cfrac{z_{i+1}}{2hi}(\cfrac{x^3}{3}-x_ix^2+x_i^2x)  +  \cfrac{z_i}{2h_i}(x_{i+1}x^2-\cfrac{x^3}{3}-x_{i+1}^2x)+ C'x+D', \text{$D\in\mathbb{R}$}\Rightarrow$$

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x^3-3x_ix^2+3x_i^2x)  +  \cfrac{z_i}{6h_i}(3x_{i+1}x^2-x^3-3x_{i+1}^2x)+ C'x+D'.$$

""","Second integration of s''")

# ╔═╡ 178b8adb-c2a7-4573-bae9-2fda47dffc71
md"""
###### 💡Complete perfect cubes and fine tune coefficients to get to:

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + C'x+D' +  \cfrac{z_{i+1}}{6hi}x_i^3 -\cfrac{z_i}{6h_i}x_{i+1}^3.$$

"""

# ╔═╡ 932db874-7e3c-4f26-b79c-10517d63d85f
hint(md"""

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x^3-3x_ix^2+3x_i^2x)  +  \cfrac{z_i}{6h_i}(3x_{i+1}x^2-x^3-3x_{i+1}^2x)+ C'x+D'.$$

In order to construct perfect cubes, we add and subtract $x_i^3$ and $x_{i+1}^3$ to the $1$st and $2$nd term of $s_i(x)$ respectively.

$$\begin{aligned}s_i(x)= \cfrac{z_{i+1}}{6hi}(x^3-3x_ix^2+3x_i^2x&-x_i^3+x_i^3) + C'x+D'+ \\
&+ \cfrac{z_i}{6h_i}(3x_{i+1}x^2-x^3-3x_{i+1}^2x-x_{i+1}^3+x_{i+1}^3).\end{aligned}$$

Now group them together,

$$s_i(x)= \cfrac{z_{i+1}}{6hi}\left( (x^3-3x_ix^2 +3x_i^2x-x_i^3)+x_i^3\right) + C'x +D' + $$

$$+\cfrac{z_i}{6h_i}\left((x_{i+1}^3-3x_{i+1}^2x+3x_{i+1}x^2- x^3) -x_{i+1}^3 \right) \Rightarrow $$


$$s_i(x)= \cfrac{z_{i+1}}{6hi}\left( (x-x_i)^3 +x_i^3\right)  +  \cfrac{z_i}{6h_i} \left( (x_{i+1}-x)^3 -x_{i+1}^3\right)+ C'x+D'\Rightarrow$$

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + C'x+D' +  \cfrac{z_{i+1}}{6hi}x_i^3 -\cfrac{z_i}{6h_i}x_{i+1}^3.$$

Now we just need to define

$$
\begin{cases}
A_i=C'\\
B_i= D' +  \cfrac{z_{i+1}}{6hi}x_i^3 -\cfrac{z_i}{6h_i}x_{i+1}^3\\

\end{cases}
$$

and $s_i(x)$ can be written as:

$$ s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + A_ix+B_i, \text{for some $A_i, B_i\in \mathbb{R}$}.$$
""","Fine tuning coefficients of second integration of s''")

# ╔═╡ 1b9b813f-6a15-4587-b3f8-acb15a37fa62
md"""
##### Writing $s_i(x)$ with the wanted form

We want to write  

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + A_ix+B_i, \text{for some $A_i, B_i\in \mathbb{R}$},$$

as 

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3+\cfrac{z_i}{6h_i}(x_{i+1}-x)^3+ 
	C_i(x-x_i)+D_i(x_{i+1}-x), \text{for some $C_i, D_i\in \mathbb{R}$}.$$

###### 💡Equate the right sides of the equations above.
"""

# ╔═╡ 5dac7f1e-386f-4ba6-8aa4-a9380f0d85b6
hint(
md"""
We have solve a system. We want the 2 following expressions to be equivalent,

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + A_ix+B_i,$$

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + C_i(x-x_i)+D_i(x_{i+1}-x).$$

Thus,

$$C_i(x-x_i)+D_i(x_{i+1}-x) = A_ix+B_i \Rightarrow (C_i-D_i)x+x_{i+1}D_i-x_iC_i=A_ix+B_i\Rightarrow$$

 $$\left.\begin{aligned}
  C_i-D_i&=A_i\\
  -x_iC_i+x_{i+1}D_i&=B_i
\end{aligned}\right\} \Rightarrow \ldots \Rightarrow \begin{aligned}
  C_i&=\cfrac{x_{i+1}A_i+B_i}{x_{i+1}-x_i}\\
  D_i&=\cfrac{x_iA_i+B_i}{x_{i+1}-x_i}
\end{aligned}$$
""" 
,"Hint")

# ╔═╡ 87d85461-c4f6-4ab8-bc2e-5fa8bc4ab3ea
md"""
So now we have: 

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3   +  \cfrac{z_i}{6h_i} (x_{i+1}-x)^3 + C_i(x-x_i)+D_i(x_{i+1}-x), \ \text{for some $C_i, D_i\in \mathbb{R}$}.$$

"""

# ╔═╡ 72305b71-eb2e-4d46-bca9-8842b4fcf46a
md"""
##### Finding $C_i, D_i$

###### 💡Use interpolation condtions for $s_i(x)$ to get to:

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3+\cfrac{z_i}{6h_i}(x_{i+1}-x)^3+ 
\Biggl(\cfrac{f(x_{i+1})}{h_i}-\cfrac{z_{i+1}}{6}h_i\Biggr)(x-x_i) +$$

$$+\Biggl(\cfrac{f(x_{i})}{h_i}-\cfrac{z_{i}}{6}h_i\Biggr)(x_{i+1}-x), \ x_i \leq x \leq x_{i+1}, \ i=0,1, \ldots, n.$$
"""

# ╔═╡ 049e4e6e-46a2-4a81-8db1-c9b42dee2479
hint(md"""
Interpolation $\forall i=0,1,\ldots ,n$ gives:

$$- \quad  s_i(x_i) = f(x_i) \Rightarrow \cfrac{z_i}{6}h_i^2+D_ih_i= f(x_i) \Rightarrow D_i= \cfrac{f(x_i)}{h_i}- \cfrac{z_ih_i}{6}.$$

$$- \quad s_i(x_{i+1}) = f(x_{i+1})\Rightarrow \cfrac{z_{i+1}}{6}h_i^2+C_ih_i=f(x_{i+1}) \Rightarrow C_i= \cfrac{f(x_{i+1})}{h_i}- \cfrac{z_{i+1}h_i}{6}.$$

We insert the expressions to find the following form of $s_i(x)$.

$$s_i(x)= \cfrac{z_{i+1}}{6hi}(x-x_i)^3+\cfrac{z_i}{6h_i}(x_{i+1}-x)^3+ 
\Biggl(\cfrac{f(x_{i+1})}{h_i}-\cfrac{z_{i+1}}{6}h_i\Biggr)(x-x_i) +$$

$$+\Biggl(\cfrac{f(x_{i})}{h_i}-\cfrac{z_{i}}{6}h_i\Biggr)(x_{i+1}-x), \ x_i \leq x \leq x_{i+1}, \ i=0,1, \ldots, n.$$
""","Applying interpolation conditions")


# ╔═╡ 18debca0-7500-4fc6-980c-33ace2d58904
md"""
##### Reaching a system to solve for $z$ 
"""

# ╔═╡ ab939990-3774-4d9d-a412-454ae85f8275
md"""

- Take the derivative of $s_i(x)$, which is

$$s_i'(x)=\cfrac{z_{i+1}}{2hi}(x-x_i)^2-\cfrac{z_i}{2h_i}(x_{i+1}-x)^2+ 
\cfrac{f(x_{i+1})-f(x_{i})}{h_i}-\cfrac{z_{i+1}-z_i}{6}h_i,$$

- Use the continuity of $s'$ at $x_i,\ i=1,2,\ldots ,n$ to get to : 

$$h_{i-1}z_{i-1}+2(h_{i-1}+h_{i})z_i +h_iz_{i+1}= 6\cfrac{f(x_{i+1})-f(x_{i})}{h_i}- 6 \cfrac{f(x_{i})-f(x_{i+1})}{h_{i-1}}.$$
"""

# ╔═╡ 50c6fc4b-8a6f-42bd-ad8d-f991b7a224c5
hint(md"""
The derivative of $s_i(x)$ is given by

$$s_i'(x)=\cfrac{z_{i+1}}{2hi}(x-x_i)^2-\cfrac{z_i}{2h_i}(x_{i+1}-x)^2+ 
\cfrac{f(x_{i+1})-f(x_{i})}{h_i}-\cfrac{z_{i+1}-z_i}{6}h_i.$$
Let $i$ be an integer $\in{1,2,\ldots,n}$.

$$s_{i-1}'(x_i)=s_i'(x_i)\Rightarrow$$

$$\Rightarrow \cfrac{z_{i}}{2h_{i-1}}
(x_i-x_{i-1})^2-\cfrac{z_{i-1}}{2h_{i-1}}(x_{i}-x_i)^2+ 
\cfrac{f(x_{i})-f(x_{i-1})}{h_{i-1}}-\cfrac{z_{i}-z_{i-1}}{6}h_{i-1} = $$

$$=\cfrac{z_{i+1}}{2hi}(x_i-x_i)^2-\cfrac{z_i}{2h_i}(x_{i+1}-x_i)^2+ 
\cfrac{f(x_{i+1})-f(x_{i})}{h_i}-\cfrac{z_{i+1}-z_i}{6}h_i \Rightarrow$$

$$\Rightarrow \cfrac{z_{i}}{2h_{i-1}}(x_i-x_{i-1})^2 + \cfrac{f(x_{i})-f(x_{i-1})}{h_{i-1}}-\cfrac{z_{i}-z_{i-1}}{6}h_{i-1} =$$

$$=-\cfrac{z_i}{2h_i}(x_{i+1}-x_i)^2+ 
\cfrac{f(x_{i+1})-f(x_{i})}{h_i}-\cfrac{z_{i+1}-z_i}{6}h_i.$$

However, 

$$h_i = x_{i+1}-x_i, \ h_{i-1} = x_{i}-x_{i-1},$$

so, supposing $y_i=f(x_i)$ for our own ease, the above expression can be written as :


$$\cfrac{z_{i}h_{i-1}}{2}+ 
\cfrac{y_i-y_{i-1}}{h_{i-1}}-\cfrac{z_{i}-z_{i-1}}{6}h_{i-1} =
-\cfrac{z_ih_i}{2}+ 
\cfrac{y_{i+1}-y_{i}}{h_i}-\cfrac{z_{i+1}-z_i}{6}h_i \Rightarrow$$


$$3h_{i-1}z_{i}+ 
6\cfrac{y_{i}-y_{i-1}}{h_{i-1}}-h_{i-1}z_{i}+h_{i-1}z_{i-1} =
-3h_iz_i+ 6\cfrac{y_{i+1}-y_{i}}{h_i}-h_iz_{i+1}+h_iz_i \Rightarrow$$


$$2h_{i-1}z_{i}+h_{i-1}z_{i-1}+ h_iz_{i+1}+2h_iz_i=
 6\cfrac{y_{i+1}-y_{i}}{h_i}-6\cfrac{y_{i}-y_{i-1}}{h_{i-1}}  \Rightarrow$$

$$h_{i-1}z_{i-1} +2(h_{i-1}+h_i)z_{i}+h_iz_{i+1}=
 6\cfrac{f(x_{i+1})-f(x_{i})}{h_i}-6\cfrac{f(x_{i})-f(x_{i-1})}{h_{i-1}}.$$
""","Using continuity of s' to reach a system of equations")

# ╔═╡ 1f5f0f1e-f529-44e8-9745-9637ffa880b3
md"""
Now, if we define

$$b_i = \cfrac{f(x_{i+1})-f(x_{i})}{h_i}, i=0,1\ldots,n-1,$$

we get:

$$h_{i-1}z_{i-1}+2(h_{i-1}+h_{i})z_i +h_iz_{i+1}=  6(b_i-b_{i-1}) \equiv v_i.$$

"""

# ╔═╡ 2df7e243-62a9-4a2a-8a87-a700e897e08c
md"""
For natural splines, we use natural conditions:

$$s''(x_0)=z_0=0, \ s''(x_n)=z_n=0,$$

hence the name **natural spline**.
"""


# ╔═╡ 9bddc31e-94ce-48e6-a516-56d4bad5386c
md"""
In this case, $z_1,\ldots,z_{n-1}$ are solutions of the system

$$
{\small
\begin{pmatrix} 2(h_1+h_2) & h_2 & 0 & \cdots & 0 & 0 \\
h_2 & 2(h_2+h_3) & h_3 & \cdots & 0 & 0 \\
0 & h_3 & 2(h_3+h_4) & \cdots & 0 & 0 \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
0 & 0 & 0 & \cdots & 2(h_{n-2}+h_{n-1}) & h_{n-1} \\
0 & 0 & 0 & \cdots & h_{n-1}  & 2(h_{n-1}+h_{n})\\
\end{pmatrix}
\begin{pmatrix}
z_1\\ z_2 \\ z_3 \\ \vdots \\ z_{n-2} \\ z_{n-1}
\end{pmatrix}
=
\begin{pmatrix}
6(b_2-b_1)\\
6(b_3-b_2)\\
6(b_4-b_3) \\
\vdots \\
6(b_{n-1}-b_{n-2})\\
6(b_n-b_{n-1})
\end{pmatrix}.}$$

The following  __error bounds__ hold true:

$$\begin{aligned}
\max |f(x)-s(x)| &\leq \frac{5}{384} \max h_i^4 \\
\max |f'(x)-s'(x)| &\leq \frac{1}{24} \max h_i^3 \\
\max |f''(x)-s''(x)| &\leq \frac{3}{8} \max h_i^2.
\end{aligned}$$

These bounds can also be used separately on each of the subintervals.
"""

# ╔═╡ ec8df0fe-9410-43e1-8927-effab7040956
md"""
### Cubic spline function

The function below takes as *inputs* 
- The $x$ and $y$ data used to plot our function $f$
- A vector $spline\_x$ with all the x-coordinates of the points that will be used to graph the cubic spline
and **solves** the system described above as of $z$ and then **returns** the y-coordinates of the cubic spline for all the x-coordinates of the input, computed using the formula derived above.
"""

# ╔═╡ 614a8149-cde3-48a1-b65c-17a8baa690e7
function NaturalCubicSpline(x,y, spline_x)
	# Initialization
	h=x[2:end]-x[1:end-1]
	f_diff=(y[2:end]-y[1:end-1])./h
	H=SymTridiagonal(2*(h[1:end-1]+h[2:end]),h[2:end-1])
	v=6*(f_diff[2:end]-f_diff[1:end-1])
	# solve for second derivatives of cubic polynomial, z
	z=H\v
	z = [0;z;0] #natural conditions of natural cubic spline
	b=f_diff-(z[2:end]-z[1:end-1]).*h/6
	# Define polynomials
	spline_y = zeros(length(spline_x))
	for i=1:length(spline_x)
		for k=1:length(x)-1
			if spline_x[i]<=x[k+1]
				spline_y[i]=y[k]-z[k]*h[k]^2/6+b[k]*(spline_x[i]-x[k])+z[k]*(x[k+1]-spline_x[i])^3/(6*h[k])+z[k+1]*(spline_x[i]-x[k])^3/(6*h[k])
				break
			end
		end
	end
return(spline_y)
end

# ╔═╡ f10c72f4-8761-4923-9d1e-2ea9073b3091
md"""
## Action 🎬
"""

# ╔═╡ cfd19e03-7edd-4856-b973-a3a88c4f6e12
md"""
#### Define ❗️your own❗️ function by editing the code block below

"""

# ╔═╡ bfc8e37e-fb05-4c69-b920-af18f63abb2d
function f(x)
    return 1/(1+25*x^2);
end

# ╔═╡ 2bc88fb8-9518-46fd-af91-e188b9183a08
Show(MIME"text/html"(),"""
		<p  style="font-size:18.0pt">
		Select the interval [a,b] for absiccas generation: <br>
		</p>""")

# ╔═╡ 7f129e62-6f22-4b97-87db-391e0945bc28
Show(MIME"text/html"(),"""
		<p  style="font-size:15.0pt">
		First select a:
		</p>""")

# ╔═╡ d7773139-3bc9-4e59-b142-e622fe9fb8ee
@bind interval_start html"""<input placeholder="-5" type="number" style="border: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ a4ffc19a-3b36-49cd-8f7d-a856c4645844
Show(MIME"text/html"(),"""
		<p  style="font-size:15.0pt">
		Now select b:
		</p>""")

# ╔═╡ a997937e-a87c-40e7-a3a6-78f9fca31f97
@bind interval_end html"""<input placeholder="-5" type="number" style="border: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 2c90abe1-12dd-48cb-a919-353ad13210e9
Show(MIME"text/html"(),"""
		<p  style="font-size:15.0pt">
		How many points of function "<i>f</i> " do you want to calculate? <br>
		</p>""")

# ╔═╡ 8e2e3594-d2f8-4fa7-a8a5-a3968d26c104
@bind f_points html"""<input placeholder="100" type="number" min="0" step="1" style="border: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 2c6fa4b0-904c-4ca7-a5e0-7d035cbc85a3
begin
	# Generate random points
		Random.seed!(125)
		#absiccas = rand(Float64, f_points) .* (b - a) .+ a
		#f_x = sort(absiccas)
	# Generate even partition of [a,b]
	x = collect(range(interval_start, stop=interval_end, length=f_points))
	y = f.(x)
	#Plotting
	plot(x, y, title="Function f graph",label="function f", linewidth=1)
	xlabel!("x")
	ylabel!("y")
end

# ╔═╡ aedf7b80-51b7-4875-a4a8-8dfab8a24f7a
Show(MIME"text/html"(),"""
		<p  style="font-size:15.0pt">
		How many points for the cubic spline polynomial do you want to calculate? <br>
		</p>""")

# ╔═╡ 6d29bac1-28e1-4238-8de4-031f4f4d79a3
@bind spline_points html"""<input placeholder="20" type="number" style="border: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 9bbf52b1-1f53-4b23-ad18-306a80c4b9e3
begin
	# Plot

	# Generate points to plot the natural cubic spline
	spline_x = collect(range(minimum(x), stop=maximum(x), length=spline_points))
	spline_y = NaturalCubicSpline(x,y, spline_x)
	#xx=range(f_x[1],f_x[end],length=lsize)
	#scatter(x,y,label="Points")
	scatter(x,y,label="Points",legend = :topleft)
	plot!(x,y, label="f")
	plot!(spline_x,spline_y, label="spline")
	#plot!(xx,ySpline,label="Spline")
end

# ╔═╡ 4d0bacd3-4d8d-45fd-a034-12f2efe5b485
begin
	difference = abs.(f.(spline_x) .- spline_y)
	plot(spline_x, difference, xlabel = "x", ylabel = "", title="Absolute difference of f-Cubic Spline",label= "Abs. error" )
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
SpecialMatrices = "928aab9d-ef52-54ac-8ca1-acd7ca42c160"

[compat]
HypertextLiteral = "~0.9.4"
Plots = "~1.38.16"
PlutoUI = "~0.7.51"
Polynomials = "~3.2.13"
SpecialMatrices = "~3.0.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "f84967c4497e0e1955f9a582c232b02847c5f589"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "4e88377ae7ebeaf29a047aa1ee40826e0b708a5d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.7.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "96d823b94ba8d187a6d8f0826e731195a74b90e9"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cf25ccb972fec4e4817764d01c82386ae94f77b4"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.14"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8b8a2fd4536ece6e554168c21860b6820a8a83db"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "19fad9cd9ae44847fe842558a744748084a722d1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "7f5ef966a02a8fdf3df2ca03108a88447cb3c6f0"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "edd1c1ac227767c75e8518defdf6e48dbfa7c3b0"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.10"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.MakieCore]]
deps = ["Observables"]
git-tree-sha1 = "9926529455a331ed73c19ff06d16906737a876ed"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.6.3"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "964cb1a7069723727025ae295408747a0b36a854"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.3.0"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1aa4b74f80b01c6bc2b89992b861b5f210e665b5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.21+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "75ca67b2c6512ad2d0c767a7cfc55e75075f8bbc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.16"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.Polynomials]]
deps = ["ChainRulesCore", "LinearAlgebra", "MakieCore", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "7beb031cf8145577fbccacd94b8a8f4ce78428d3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.0"

[[deps.SpecialMatrices]]
deps = ["LinearAlgebra", "Polynomials"]
git-tree-sha1 = "8fd75ee3d16a83468a96fd29a1913fb170d2d2fd"
uuid = "928aab9d-ef52-54ac-8ca1-acd7ca42c160"
version = "3.0.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═adc6a9ca-1909-11ee-10a2-51fed6f566e8
# ╠═cfbcfd60-8b67-4ffc-9afb-fadf358241bd
# ╟─e2bdfd0e-56f6-42d0-98f7-8291fe573708
# ╟─69cf4499-1eb0-461f-bf95-6759c62b12b5
# ╟─a23a9d2a-a7a9-4abf-8e85-a7b28505b3d0
# ╟─5fb34831-1d13-44a3-88ba-ab86176c30b4
# ╟─167662f5-23ba-46a2-91fc-a726f8f6efda
# ╟─6454e89d-afbb-469a-9b17-71730fa982dc
# ╟─57b666b8-a154-4cd4-8b4c-dceac7f21d03
# ╟─38201ff6-817f-4fb9-b36b-268289ed820c
# ╟─8c7e0bb9-7ccc-4337-be6d-3f0d97d39100
# ╟─b563e3a0-aae7-4046-b531-5ff2c9c71912
# ╟─78b533d8-1737-4863-a393-907900e108ee
# ╟─07d1b6e3-a0f8-4cb8-9b2d-5643e14f6fce
# ╟─178b8adb-c2a7-4573-bae9-2fda47dffc71
# ╟─932db874-7e3c-4f26-b79c-10517d63d85f
# ╟─1b9b813f-6a15-4587-b3f8-acb15a37fa62
# ╟─5dac7f1e-386f-4ba6-8aa4-a9380f0d85b6
# ╟─87d85461-c4f6-4ab8-bc2e-5fa8bc4ab3ea
# ╟─72305b71-eb2e-4d46-bca9-8842b4fcf46a
# ╟─049e4e6e-46a2-4a81-8db1-c9b42dee2479
# ╟─18debca0-7500-4fc6-980c-33ace2d58904
# ╟─ab939990-3774-4d9d-a412-454ae85f8275
# ╟─50c6fc4b-8a6f-42bd-ad8d-f991b7a224c5
# ╟─1f5f0f1e-f529-44e8-9745-9637ffa880b3
# ╟─2df7e243-62a9-4a2a-8a87-a700e897e08c
# ╟─9bddc31e-94ce-48e6-a516-56d4bad5386c
# ╟─ec8df0fe-9410-43e1-8927-effab7040956
# ╠═614a8149-cde3-48a1-b65c-17a8baa690e7
# ╟─f10c72f4-8761-4923-9d1e-2ea9073b3091
# ╟─cfd19e03-7edd-4856-b973-a3a88c4f6e12
# ╠═bfc8e37e-fb05-4c69-b920-af18f63abb2d
# ╟─2bc88fb8-9518-46fd-af91-e188b9183a08
# ╟─7f129e62-6f22-4b97-87db-391e0945bc28
# ╟─d7773139-3bc9-4e59-b142-e622fe9fb8ee
# ╟─a4ffc19a-3b36-49cd-8f7d-a856c4645844
# ╟─a997937e-a87c-40e7-a3a6-78f9fca31f97
# ╟─2c90abe1-12dd-48cb-a919-353ad13210e9
# ╟─8e2e3594-d2f8-4fa7-a8a5-a3968d26c104
# ╠═2c6fa4b0-904c-4ca7-a5e0-7d035cbc85a3
# ╟─aedf7b80-51b7-4875-a4a8-8dfab8a24f7a
# ╟─6d29bac1-28e1-4238-8de4-031f4f4d79a3
# ╠═9bbf52b1-1f53-4b23-ad18-306a80c4b9e3
# ╠═4d0bacd3-4d8d-45fd-a034-12f2efe5b485
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
