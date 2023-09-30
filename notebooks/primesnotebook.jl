### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 2f6761a3-0733-44d8-9581-aa16472d8bfb
md"# Prime Check Algorithms Benchmarks"

# ╔═╡ f5979170-91d4-4ef3-8792-7f2a2e3a991a
md""" 

## Purpose of notebook

Our aim is to compare the speed of Julia, Matlab & Python on $3$ algorithms that check if a given number is prime or not."""

# ╔═╡ 3cba36c2-f149-4ae2-b655-0190ca948ae7
md"## Bruteforce Algorithm"

# ╔═╡ c93b8c85-d3a3-455f-bd9b-0df48607e9ba
md"""
### Mathematical Background

Let $N$ be the number that we want to check. Then it's a fact that $N$ is prime if and only if the only divisors of $N$ are $1$, $N$.

### Implementation

 - We use a counter for the divisors of the number, starting from $1$ ($1$ is always a divisor of any number). 
- The moment the algorithm finds another divisor of $Ν$ the value of the counter increases by one. 
- If we reach $N$ without finding another divisor (we exclude the number we examine, because it divides itself), then $Ν$ is prime."

**Complexity**: Ο($n$)
"""

# ╔═╡ 76ab8cff-c286-431c-b2ac-e4af7fd812a5
md"""

#### The algorithm in pseudo language

```plaintext
# Brute-Force Algorithm in Pseudocode

print('Give an integer number n='\n)
read(n)
@time begin
counter=1
	for i=2:n
		if (rem(n,i))==0
			counter=counter + 1
	    end
	end
	if $counter==2$
		print('The inputed number is prime')
	else
		print('The inputed number is not prime')
	end
@time end    
```
"""

# ╔═╡ 3494f126-7636-4a70-bbf6-97898b890664
md"#### The algorithm in Julia"

# ╔═╡ dcfd8c2b-2497-4d73-89e8-4c27cd08abb7
# Brute-Force Algorithm 
  function primes2(n::Number)
   # primes2.m
   counter= 1
   for i in 2: n
    if (rem(n,i)==0)
      counter=counter+1
    end
   end
   if counter==1 
    print("$n is prime.")
   else
    print("$n is not prime.")
   end
  end

# ╔═╡ a8f7616f-fc60-4253-8e94-dd428c9254a7
md"##### ❗️Edit the code block below to write a number and test if it's prime!"

# ╔═╡ 76ae52d1-5b10-44bb-819a-15e9892f8c7c
@time primes2(1000000)

# ╔═╡ 640fdd44-8856-4206-b43a-84c03ad10f06
md"""
#### The algorithm in Python

```python
# Brute-Force Algorithm 

import time
import numpy as np

n= int(input('Give intenger greater than 1: '))
st = time.time()  
numbers = np.arange(1, n + 1)
divisors = np.remainder(n, numbers)
divisor_count = np.count_nonzero(divisors == 0)
if divisor_count == 2: 
	print( n ' is prime .')
else:
	print(n ' is not prime.')
et = time.time()
elapsed_time = et - st
print('Execution time:', elapsed_time, 'seconds')
```
"""

# ╔═╡ 5b6919dd-bc64-4e80-9441-656884911a61
md"""
#### The algorithm in Matlab

```julia
% Brute-Force Algorithm 
% primes1.m

n=0;
while n<2
	n = input('Give intenger greater than 1: '); 
end
counter=1
for i=2:n
	if (rem(n,i))==0
		counter=counter + 1
	end
end
if counter==2
	fprintf('%d is prime \n', n);
else
	fprintf('%d is not prime\n', n);
end
```
"""

# ╔═╡ 48e22ed0-fd12-4302-b4ae-6e6b675e2e88
md"#### Performance of Brute-force algorithm"

# ╔═╡ dca57801-534d-4b16-b0e8-6e8d6aee4c9e
html"""<table>
  <tr>
    <th>n</th>
    <th>Octave</th>
    <th>Matlab</th>
	<th>Julia</th>
	<th>Python</th>
  </tr>
  <tr>
    <td align="right">1,000,000</td>
    <td align="right">4.33 sec</td>
    <td align="right">0.025 sec</td>
	<td align="right">0.004 sec</td>
	<td align="right">0.019 sec</td>
  </tr>
  <tr>
    <td align="right">10,000,000</td>
    <td align="right">42 sec</td>
    <td align="right">0.15 sec</td>
	<td align="right">0.03 sec</td>
	<td align="right">0.12 sec</td>
  </tr>
  <tr>
    <td align="right">100,000,000</td>
    <td align="right"> 7 min 25 sec</td>
    <td align="right">1.41 sec</td>
	<td align="right">0.35 sec</td>
	<td align="right">0.66 sec</td>
  </tr>
  <tr>
    <td align="right">1,000,000,000</td>
    <td align="right"> 1 hour 11 min</td>
    <td align="right">15.03 sec</td>
	<td align="right">3.69 sec</td>
	<td align="right">7.41 sec</td>
  </tr>
</table>
"""

# ╔═╡ 5c3d1bc1-23c6-488c-a04f-fdc676fe97de
md"
 All of the programs were executed in a PC with:
- Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
- 16 GB of RAM memory
- NVIDIA GeForce GTX 1660 graphics card
- Samsung EVO 870 SSD hard drive
"

# ╔═╡ 44dfebc1-5dab-408c-aca1-31236b047026
md"""
## Improved Bruteforce Algorithm

### Description of the method

- Based on the remark that there is no number that has divisors greater than $Ν/2$, we modify the previous algorithm by now examining divisors $M$, such that $Μ\leqΝ/2$. 
- In order for $N$ to be prime the counter has to have the value of $1$."

**Complexity:** Ο($n/2$)
"""

# ╔═╡ f60bd07a-85ad-4936-a8d5-bbebc5eae248
md"""

#### The algorithm in pseudo language

```plaintext
# Improved Brute-Force Algorithm in Pseudocode

print('Give an integer number n= ')
read(n)
@time begin
counter=1
for i=2:(n/2)
	if (rem(n,i))==0
		counter=counter + 1
	end
end
if counter==1
	print('The inputed number is prime')
else
	print('The inputed number is not prime')
end
@time end    
```
"""

# ╔═╡ b444d59e-ded5-416f-92db-081659c34a67
md"#### The algorithm in Julia"

# ╔═╡ 3a9fb962-1bbb-4a11-8010-0274c0e4603a
#Improved Brute-force algorithm

function primes1(n::Number)
   # primes2.m
   counter= 1
   for i in 2: n
    if (rem(n,i)==0)
      counter=counter+1
    end
   end
   if counter==1 
    print("$n is prime.")
   else
    print("$n is not prime.")
   end
  end

# ╔═╡ e70c5c85-c458-42d6-b1be-29487b5f27c9
md"##### ❗️Edit the code block below to write a number and test if it's prime!"

# ╔═╡ 44bfa42b-95eb-4b52-b614-2f407428e456
@time primes1(1000000)

# ╔═╡ 743b8553-6943-4e36-b969-b1bf5b160714
md"""
#### The algorithm in Python

```python
#Improved Brute-force algorithm

import time
import numpy as np
n= int(input('Give intenger greater than 1: '))
st = time.time()  
numbers = np.arange(1, n // 2 + 1)
divisors = np.remainder(n, numbers)
divisor_count = np.count_nonzero(divisors == 0)
if divisor_count == 1: 
	print( n ' is prime .')
else:
	print(n ' is not prime.')
et = time.time()
elapsed_time = et - st
print('Execution time:', elapsed_time, 'seconds')
```

"""

# ╔═╡ 8d82c6c8-1e3b-4bdd-a07a-5efd62f83e14
md"""
#### The algorithm in Matlab

```julia
% Improved Brute-force algorithm
% primes1.m

n=0;
while n<2
	n = input('Give intenger greater than 1: '); 
end
counter=1
for i=2:(n/2)
	if (rem(n,i))==0
		counter=counter + 1
	end
end
if counter==1
	fprintf('%d is prime \n', n);
else
	fprintf('%d is not prime\n', n);
end
```
"""

# ╔═╡ 50a17efc-4c91-497f-a328-0aa352b5c1d0
md"#### Performance of Improved Brute Force Algorithm "

# ╔═╡ c0f09876-ea8a-4d4d-b027-62f215cebd98
html"""<table>
  <tr>
    <th>n</th>
    <th>Octave</th>
    <th>Matlab</th>
	<th>Julia</th>
	<th>Python</th>
  </tr>
  <tr>
    <td align="right">1,000,000</td>
    <td align="right">2.12 sec</td>
    <td align="right">0.016 sec</td>
	<td align="right">0.002 sec</td>
	<td align="right">0.015 sec</td>
  </tr>
  <tr>
    <td align="right">10,000,000</td>
    <td align="right">21.24 sec</td>
    <td align="right">0.085 sec</td>
	<td align="right">0.022 sec</td>
	<td align="right">0.048 sec</td>
  </tr>
  <tr>
    <td align="right">100,000,000</td>
    <td align="right"> 3 min 32 sec</td>
    <td align="right">0.85 sec</td>
	<td align="right">0.2 sec</td>
	<td align="right">0.34 sec</td>
  </tr>
  <tr>
    <td align="right">1,000,000,000</td>
    <td align="right"> 37 min 15 sec</td>
    <td align="right"> 8.18 sec</td>
	<td align="right"> 2.09 sec</td>
	<td align="right"> 3.33 sec</td>
  </tr>
</table>
"""

# ╔═╡ 74721157-70de-4e54-aaa2-8fbf409096e9
md"
 All of the programs were executed in a PC with:
- Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
- 16 GB of RAM memory
- NVIDIA GeForce GTX 1660 graphics card
- Samsung EVO 870 SSD hard drive
"

# ╔═╡ c300c725-74ea-453b-98c3-08867cffcb94
md"## The Root Algorithm"

# ╔═╡ c295166e-b0f2-4ee4-8f8d-86f765e00c6a
md"#### Description of the method"

# ╔═╡ c09d1d8e-feaa-42f7-966e-20d8e160545b
md"
### Mathematical background

A number $Ν$ is not prime when it has (at least) two divisors greater than $1$. In this case at least of the two, is smaller than the square root of the number. 

### Implementation

We modify the second method by searching for divisors smaller than $\sqrt{Ν}$ (given that $\sqrt{N}$ is not an integer-in this case $N$ is not prime beacuse its square root divides it). 

Complexity: Ο($\sqrt{n}$)"

# ╔═╡ 3668abc8-c4f9-4741-b591-d9490956a92f
md"""

#### The algorithm in pseudo language

```plaintext
# Root algorithm in Pseudocode

print('Give an integer number n= ')
read(n)
@time begin
counter=1
for i=2:floor(sqrt(n))
	if (rem(n,i))==0
		counter=counter + 1
	end
end
if counter==1
	print('O n is prime')
else
	print('O n is not prime')
end
@time end    
```
"""

# ╔═╡ 49b842d9-05c4-4bd7-a924-8b4c31faa618
md"#### The algorithm in Julia"

# ╔═╡ b5d2b8a1-bbe5-421b-96d3-e1e7a2c94326
# Root algorithm

  function primes(n::Number)
   # primes3.m
   counter= 1
   for i in 2:sqrt(fld(n,2))
    if (rem(n,i)==0)
      counter=counter+1
    end
   end
   if counter==1 
    print("$n is prime.")
   else
    print("$n is not prime.")
   end
  end

# ╔═╡ 5cab69db-1c8c-4f3d-b55b-f4d4d220a341
md"##### ❗️Edit the code block below to write a number and test if it's prime!"

# ╔═╡ 1f585d28-81cc-44fe-bf68-ded4ec427636
@time primes(1000000)

# ╔═╡ 4333c797-f26a-40bc-9857-8290438b3613
md"""
#### The algorithm in Python

```python
#Root algorithm

import time
import numpy as np
n= int(input('Give intenger greater than 1: '))
st = time.time()  
numbers = np.arange(1, int(np.sqrt(n)) + 1)
divisors = np.remainder(n, numbers)
divisor_count = np.count_nonzero(divisors == 0)
if divisor_count == 1: 
	print( n ' is prime .')
else:
	print(n ' is not prime.')
et = time.time()
elapsed_time = et - st
print('Execution time:', elapsed_time, 'seconds')
```

"""

# ╔═╡ 94cc5583-2bc4-454d-9a90-123f9a9683b2
md"""
#### The algorithm in Matlab

```julia
% Root algorithm
% primes.m


n=0;
while n<2
n = input('Give intenger greater than 1: '); 
end
counter=1
for i=2:floor(sqrt(n))
	if (rem(n,i))==0
		counter=counter + 1
	end
end
if counter==1
	fprintf('%d is prime \n', n);
else
	fprintf('%d is not prime\n', n);
end
```
"""

# ╔═╡ d90e9f30-0907-486e-b814-a0c47420c813
md"#### Performance of Root Algorithm"

# ╔═╡ 1e0301a3-5a85-4f8e-a38e-c41ab2f25f66
html"""<table>
  <tr>
    <th>n</th>
    <th>Octave</th>
    <th>Matlab</th>
	<th>Julia</th>
	<th>Python</th>
  </tr>
  <tr>
    <td align="right">1,000,000</td>
    <td align="right">0.005 sec</td>
    <td align="right">0.0010 sec</td>
	<td align="right">0.00018 sec</td>
	<td align="right">0.010 sec</td>
  </tr>
  <tr>
    <td align="right">10,000,000</td>
    <td align="right">0.014 sec</td>
    <td align="right">0.0016 sec</td>
	<td align="right">0.00022 sec</td>
	<td align="right">0.011 sec</td>
  </tr>
  <tr>
    <td align="right">100,000,000</td>
    <td align="right"> 0.045 sec</td>
    <td align="right">0.0018 sec</td>
	<td align="right">0.00033 sec</td>
	<td align="right">0.013 sec</td>
  </tr>
  <tr>
    <td align="right">1,000,000,000</td>
    <td align="right"> 0.14 sec</td>
    <td align="right"> 0.00022 sec</td>
	<td align="right"> 0.00066 sec</td>
	<td align="right"> 0.016 sec</td>
  </tr>
</table>
"""

# ╔═╡ 5a3b743d-065f-45b1-ba40-b8ece8693fce
md"
 All of the programs were executed in a PC with:
- Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
- 16 GB of RAM memory
- NVIDIA GeForce GTX 1660 graphics card
- Samsung EVO 870 SSD hard drive
"

# ╔═╡ f8b59e35-0bd5-4f2b-b7eb-93e80dc94187
md"
## Conclusions

-  We notice that the root method (Complexity: $Ο(\sqrt{n})$ is the most efficient one,  having the fastest times in all of the calculations that were made. On the contrary, the Bruteforce algorithm (Complexity: $Ο(n)$) is the slowest one by far. Then, the improved Bruteforce method (Complexity: $Ο(n/2)$)  shows  that it speeds up the procedure , but still remains slower than the Root algorithm. Those results are somewhat of expected based on the complexity of the algorithms respectively.
-  After comparing the programming languages Julia, Matlab and Python, we notice very high speeds of execution in Julia, which allows us to test these algorithms with big input values. Python and Matlab have similar times of execution (both slower than Julia) but the fact that Python is easier to use, gives it the edge over Matlab. However, that does not forbid us from making calculations with big values in both of these languages because they are still quite fast. Last but not least, the aforementioned languages record overwhelmingly better execution times than Octave.
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─2f6761a3-0733-44d8-9581-aa16472d8bfb
# ╟─f5979170-91d4-4ef3-8792-7f2a2e3a991a
# ╟─3cba36c2-f149-4ae2-b655-0190ca948ae7
# ╟─c93b8c85-d3a3-455f-bd9b-0df48607e9ba
# ╟─76ab8cff-c286-431c-b2ac-e4af7fd812a5
# ╟─3494f126-7636-4a70-bbf6-97898b890664
# ╠═dcfd8c2b-2497-4d73-89e8-4c27cd08abb7
# ╟─a8f7616f-fc60-4253-8e94-dd428c9254a7
# ╠═76ae52d1-5b10-44bb-819a-15e9892f8c7c
# ╟─640fdd44-8856-4206-b43a-84c03ad10f06
# ╟─5b6919dd-bc64-4e80-9441-656884911a61
# ╟─48e22ed0-fd12-4302-b4ae-6e6b675e2e88
# ╟─dca57801-534d-4b16-b0e8-6e8d6aee4c9e
# ╟─5c3d1bc1-23c6-488c-a04f-fdc676fe97de
# ╟─44dfebc1-5dab-408c-aca1-31236b047026
# ╟─f60bd07a-85ad-4936-a8d5-bbebc5eae248
# ╟─b444d59e-ded5-416f-92db-081659c34a67
# ╠═3a9fb962-1bbb-4a11-8010-0274c0e4603a
# ╟─e70c5c85-c458-42d6-b1be-29487b5f27c9
# ╠═44bfa42b-95eb-4b52-b614-2f407428e456
# ╟─743b8553-6943-4e36-b969-b1bf5b160714
# ╟─8d82c6c8-1e3b-4bdd-a07a-5efd62f83e14
# ╟─50a17efc-4c91-497f-a328-0aa352b5c1d0
# ╟─c0f09876-ea8a-4d4d-b027-62f215cebd98
# ╟─74721157-70de-4e54-aaa2-8fbf409096e9
# ╟─c300c725-74ea-453b-98c3-08867cffcb94
# ╟─c295166e-b0f2-4ee4-8f8d-86f765e00c6a
# ╟─c09d1d8e-feaa-42f7-966e-20d8e160545b
# ╟─3668abc8-c4f9-4741-b591-d9490956a92f
# ╟─49b842d9-05c4-4bd7-a924-8b4c31faa618
# ╠═b5d2b8a1-bbe5-421b-96d3-e1e7a2c94326
# ╟─5cab69db-1c8c-4f3d-b55b-f4d4d220a341
# ╠═1f585d28-81cc-44fe-bf68-ded4ec427636
# ╟─4333c797-f26a-40bc-9857-8290438b3613
# ╟─94cc5583-2bc4-454d-9a90-123f9a9683b2
# ╟─d90e9f30-0907-486e-b814-a0c47420c813
# ╟─1e0301a3-5a85-4f8e-a38e-c41ab2f25f66
# ╟─5a3b743d-065f-45b1-ba40-b8ece8693fce
# ╟─f8b59e35-0bd5-4f2b-b7eb-93e80dc94187
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
