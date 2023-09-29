### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 2f6761a3-0733-44d8-9581-aa16472d8bfb
md"# In these project we compare 3 algorithms that define if a number is prime or not"

# ╔═╡ 3cba36c2-f149-4ae2-b655-0190ca948ae7
md"## Bruteforce Algorithm"

# ╔═╡ 9e13bda0-8f43-4d95-b6af-112545fce090
md"#### Description of the method"

# ╔═╡ 9c426c10-18b5-11ee-3f0a-57e2a4f1d10b
md"In this first method $(Bruteforce)$  we examine all the numbers $Μ\leqΝ$, where $Ν$ stands for the number that we check if it is prime or not . We use a counter for the divisors of the number, which starts from 1 (Number 1 is always a divisor of any number). The moment the algorithm finds another divisor of $Ν$ the value of the counter increases by one. If we run out of numbers minor or equal to $Μ$ without finding another divisor (we exclude the number we examine, because it divides itself), then $Ν$ is prime."

# ╔═╡ 76ab8cff-c286-431c-b2ac-e4af7fd812a5
md"#### The algorithm in pseudo language"

# ╔═╡ 31fd2f6e-c39c-43a2-bc29-7e0ce6bf52be
md"
1. print 'Give an integer number n='\n asd
2. Read $n$
3.   @time begin
4.  $counter=1$
5.  for $i=2:n$
6.   if $(rem(n,i))==0$
7.     counter=counter + 1
8.   end
9.  end
10.  if $counter==2$
11.     print 'O n is prime'
12.  else
13.     print 'O n is not prime'
14.  end
15.   @time end
"

# ╔═╡ 3494f126-7636-4a70-bbf6-97898b890664
md"#### The algorithm in Julia"

# ╔═╡ dcfd8c2b-2497-4d73-89e8-4c27cd08abb7
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

# ╔═╡ 76ae52d1-5b10-44bb-819a-15e9892f8c7c
#"In the parenthesis below write a number greater than 1 in order to test the programm"
@time primes2(1000000)

# ╔═╡ 6ecd6581-bcab-47aa-be5e-557339e53412
md"#### The algorithm in Python"

# ╔═╡ 640fdd44-8856-4206-b43a-84c03ad10f06
md"
 1.  import time
 2.  import numpy as np
 3.  n= int(input('Give intenger greater than 1: '))
 4.  st = time.time()  
 5.  numbers = np.arange(1, n + 1)
 6.  divisors = np.remainder(n, numbers)
 7.  divisor_count = np.count_nonzero(divisors == 0)
 8.  if divisor_count == 2: 
9.   print( n ' is prime .')
10.  else:
11.   print(n ' is not prime.')
12.  et = time.time()
13.  elapsed_time = et - st
14.  print('Execution time:', elapsed_time, 'seconds')
"

# ╔═╡ 5b6919dd-bc64-4e80-9441-656884911a61
md"#### The algorithm in Matlab"

# ╔═╡ 07d1d0a2-660c-4bcb-b341-286725011193
md"
1.  % primes1.m
2.  n=0;
3.  while $n<2$
4.   n = input('Give intenger greater than 1: '); 
5. end
6.  $counter=1$
7.  for $i=2:n$
8.   if $(rem(n,i))==0$
9.     counter=counter + 1
10.   end
11.  end
12.  if $counter==2$
13.  fprintf('%d is prime \n', n);
14.  else
15.   fprintf('%d is not prime\n', n);
16.  end
"

# ╔═╡ c6f53f87-3cb0-4ff9-bca9-067a6f3815c0
md"#### Numerical implementation "

# ╔═╡ 48e22ed0-fd12-4302-b4ae-6e6b675e2e88
md"Complexity: Ο($n$)



Performance of the the 3 algorithms: "

# ╔═╡ ffc866b1-688f-4b82-b547-54558348267c
md"
| n  | Octave |Matlab | Julia | Python |
|--- | ------ | ------- | ----- | ------ |
|1000000| 4.33 sec|0.025 sec|0.004 sec|0.019 sec|
|10000000| 42 sec|0.15 sec| 0,03 sec| 0.12 sec|
|100000000| 7 min 35 sec|1.41 sec|0,35 sec|0.66 sec|
|1000000000| 1 hour 11 min|15.03 sec|3.69 sec|7.41 sec|
"

# ╔═╡ 5c3d1bc1-23c6-488c-a04f-fdc676fe97de
md"
 All of the programs were executed in a pc with:
1. an Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
2. 16 GB of RAM memory
3. an NVIDIA GeForce GTX 1660 graphics card
4. and an a Samsung EVO 870 SSD hard drive
"

# ╔═╡ 44dfebc1-5dab-408c-aca1-31236b047026
md"## Improved Bruteforce Algorithm"

# ╔═╡ 3071932c-3d5e-40d9-bb49-ac24f7bc71b9
md"#### Description of the method"

# ╔═╡ 3bf38f07-da8e-4429-bcc0-612ec5f6ddb9
md"Based on the remark that there is no number that has  divisors greater than $Ν/2$, we modify the previous algorithm by now examining all the numbers $Μ\leqΝ/2$. By doing so we double up the speed of execution compared to the first method. Also in this case, in order for the number to be prime the counter has to have the value of 1."

# ╔═╡ f60bd07a-85ad-4936-a8d5-bbebc5eae248
md"#### The algorithm in pseudo language"

# ╔═╡ c49b9e67-aba8-4ab9-8f9e-d20bbc9ca1b3
md"
1. print 'Give an integer number n= '
2. Read $n$
3.   @time begin
4.  $counter=1$
5.  for $i=2:(n/2)$
6.   if $(rem(n,i))==0$
7.     counter=counter + 1
8.   end
9.  end
10.  if $counter==1$
11.     print 'O n is prime'
12.  else
13.     print 'O n is not prime'
14.  end
15.   @time end
"

# ╔═╡ b444d59e-ded5-416f-92db-081659c34a67
md"#### The algorithm in Julia"

# ╔═╡ 3a9fb962-1bbb-4a11-8010-0274c0e4603a
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

# ╔═╡ 44bfa42b-95eb-4b52-b614-2f407428e456
#"In the parenthesis below write a number greater than 1 in order to test the programm"
@time primes1(1000000)

# ╔═╡ 743b8553-6943-4e36-b969-b1bf5b160714
md"#### The algorithm in Python"

# ╔═╡ 8b6fb851-2b70-4b06-9dbd-dbcb608ab76a
md"
 1.  import time
 2.  import numpy as np
 3.  n= int(input('Give intenger greater than 1: '))
 4.  st = time.time()  
 5. numbers = np.arange(1, n // 2 + 1)
 6.  divisors = np.remainder(n, numbers)
 7.  divisor_count = np.count_nonzero(divisors == 0)
 8.  if divisor_count == 1: 
9.   print( n ' is prime .')
10.  else:
11.   print(n ' is not prime.')
12.  et = time.time()
13.  elapsed_time = et - st
14.  print('Execution time:', elapsed_time, 'seconds')
"

# ╔═╡ 8d82c6c8-1e3b-4bdd-a07a-5efd62f83e14
md"#### The algorithm in Matlab"

# ╔═╡ 18ce520b-bbd9-4870-a396-adf139d8ab72
md"
1.  % primes1.m
2.  n=0;
3.  while $n<2$
4.   n = input('Give intenger greater than 1: '); 
5. end
6.  $counter=1$
7.  for $i=2:(n/2)$
8.   if $(rem(n,i))==0$
9.     counter=counter + 1
10.   end
11.  end
12.  if $counter==1$
13.  fprintf('%d is prime \n', n);
14.  else
15.   fprintf('%d is not prime\n', n);
16.  end
"

# ╔═╡ 50a17efc-4c91-497f-a328-0aa352b5c1d0
md"#### Numerical implementation "

# ╔═╡ 22012d47-9a83-4ad6-8ab6-866489f36026
md"Complexity: Ο($n/2$)



Performance of the the 3 algorithms: "

# ╔═╡ 55e5292c-016a-42e4-b9f6-1f0236fb3854
md"
| n  | Octave |Matlab | Julia | Python |
|--- | ------ | ------- | ----- | ------ |
|1000000| 2.12 sec|0.016 sec|0.002 sec|0.015 sec|
|10000000| 21.24 sec|0.085 sec| 0,022 sec| 0.048 sec|
|100000000| 3 min 32 sec|0.85 sec|0,2 sec|0.34 sec|
|1000000000| 37 min and 15 sec |8.18 sec|2.09 sec|3.33 sec|
"

# ╔═╡ 74721157-70de-4e54-aaa2-8fbf409096e9
md"
 All of the programs were executed in a pc with:
1. an Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
2. 16 GB of RAM memory
3. an NVIDIA GeForce GTX 1660 graphics card
4. and an a Samsung EVO 870 SSD hard drive
"

# ╔═╡ c300c725-74ea-453b-98c3-08867cffcb94
md"## The Root Algorithm"

# ╔═╡ c295166e-b0f2-4ee4-8f8d-86f765e00c6a
md"#### Description of the method"

# ╔═╡ c09d1d8e-feaa-42f7-966e-20d8e160545b
md"We create this method by noticing that a number $Ν$ is not prime when it has (at least) two divisors greater than 1. In this case at least one of its divisors is minor than the square root of the number. We modify the second method by now examining all the numbers that are minor to the square root of $Ν$. If the latter one is not an integer, otherwise the number is not prime, because its square root divides it."

# ╔═╡ 3668abc8-c4f9-4741-b591-d9490956a92f
md"#### The algorithm in pseudo language"

# ╔═╡ 3308997a-6176-4db7-8dd8-d9c253197e90
md"
1. print 'Give an integer number n= '
2. Read $n$
3.   @time begin
4.  $counter=1$
5.   for $i=2:floor(sqrt(n))$
6.   if $(rem(n,i))==0$
7.     counter=counter + 1
8.   end
9.  end
10.  if $counter==1$
11.     print 'O n is prime'
12.  else
13.     print 'O n is not prime'
14.  end
15.   @time end
"

# ╔═╡ 49b842d9-05c4-4bd7-a924-8b4c31faa618
md"#### The algorithm in Julia"

# ╔═╡ b5d2b8a1-bbe5-421b-96d3-e1e7a2c94326
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

# ╔═╡ 1f585d28-81cc-44fe-bf68-ded4ec427636
#"In the parenthesis below write a number greater than 1 in order to test the programm"
@time primes(1000000)

# ╔═╡ 4333c797-f26a-40bc-9857-8290438b3613
md"#### The algorithm in Python"

# ╔═╡ eed02bd4-5d44-4604-879a-44411d79a76d
md"
 1.  import time
 2.  import numpy as np
 3.  n= int(input('Give intenger greater than 1: '))
 4.  st = time.time()  
 5.  numbers = np.arange(1, int(np.sqrt(n)) + 1)
 6.  divisors = np.remainder(n, numbers)
 7.  divisor_count = np.count_nonzero(divisors == 0)
 8.  if divisor_count == 1: 
9.   print( n ' is prime .')
10.  else:
11.   print(n ' is not prime.')
12.  et = time.time()
13.  elapsed_time = et - st
14.  print('Execution time:', elapsed_time, 'seconds')
"

# ╔═╡ 94cc5583-2bc4-454d-9a90-123f9a9683b2
md"#### The algorithm in Matlab"

# ╔═╡ dcce9b04-d7e0-4041-aa92-57964f69d4b2
md"
1.  % primes1.m
2.  n=0;
3.  while $n<2$
4.   n = input('Give intenger greater than 1: '); 
5. end
6.  $counter=1$
7.  for $i=2:floor(sqrt(n))$
8.   if $(rem(n,i))==0$
9.     counter=counter + 1
10.   end
11.  end
12.  if $counter==1$
13.  fprintf('%d is prime \n', n);
14.  else
15.   fprintf('%d is not prime\n', n);
16.  end
"

# ╔═╡ 35180e55-dbc9-4961-8af1-b808a00a3950
md"#### Numerical implementation "


# ╔═╡ d90e9f30-0907-486e-b814-a0c47420c813
md"Complexity: Ο($\sqrt{n}$)



Performance of the the 3 algorithms: "

# ╔═╡ 4822cd69-1b8c-447c-a7b3-63985a9ade58
md"
| n  | Octave |Matlab | Julia | Python |
|--- | ------ | ------- | ----- | ------ |
|1000000| 0,005 sec|0.0010 sec|0.004 sec|0.010 sec|
|10000000| 0.014 sec|0.0016 sec| 0,03 sec| 0.011 sec|
|100000000|0.045 sec|0.0018 sec|0,35 sec|0.013 sec|
|1000000000| 0.14 sec |0.00022 sec|3.69 sec|0.016 sec|
"

# ╔═╡ 5a3b743d-065f-45b1-ba40-b8ece8693fce
md"
 All of the programs were executed in a pc with:
1. an Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz Processor
2. 16 GB of RAM memory
3. an NVIDIA GeForce GTX 1660 graphics card
4. and an a Samsung EVO 870 SSD hard drive
"

# ╔═╡ 6f2d98a0-9620-4eac-ab33-4465a73857a9
md"## Conclusions"

# ╔═╡ f8b59e35-0bd5-4f2b-b7eb-93e80dc94187
md"
* As for the algorithms themselves, we notice that the root method (Complexity: $Ο(\sqrt{n})$ is the most efficient one,  having the fastest times in all of the calculations that were made. On the contrary, the Bruteforce algorithm (Complexity: $Ο(n)$) is the slowest one by far. Then, the improved Bruteforce method (Complexity: $Ο(n/2)$)  shows  that it speeds up the procedure , but still remain slower than the root algorithm. Those results are somewhat of expected based on the complexity of the algorithms respectively.
* Moreover, after comparing the three programming languages (Julia, Matlab and Python), we notice very high speeds of execution in Julia, fact that allow us to test these algorithms with high input values. Python and Matlab have similar times of execution (both slower than Julia) but the fact that Python is easier to use, gives it the edge over Matlab. However, that does not forbid us from making calculations with high values in both of these languages because they are still quite fast. Last but not least, all of the above languages record overwhelmingly better execution times than Octave.
"

# ╔═╡ Cell order:
# ╠═2f6761a3-0733-44d8-9581-aa16472d8bfb
# ╠═3cba36c2-f149-4ae2-b655-0190ca948ae7
# ╠═9e13bda0-8f43-4d95-b6af-112545fce090
# ╠═9c426c10-18b5-11ee-3f0a-57e2a4f1d10b
# ╠═76ab8cff-c286-431c-b2ac-e4af7fd812a5
# ╠═31fd2f6e-c39c-43a2-bc29-7e0ce6bf52be
# ╠═3494f126-7636-4a70-bbf6-97898b890664
# ╠═dcfd8c2b-2497-4d73-89e8-4c27cd08abb7
# ╠═76ae52d1-5b10-44bb-819a-15e9892f8c7c
# ╠═6ecd6581-bcab-47aa-be5e-557339e53412
# ╠═640fdd44-8856-4206-b43a-84c03ad10f06
# ╠═5b6919dd-bc64-4e80-9441-656884911a61
# ╠═07d1d0a2-660c-4bcb-b341-286725011193
# ╠═c6f53f87-3cb0-4ff9-bca9-067a6f3815c0
# ╠═48e22ed0-fd12-4302-b4ae-6e6b675e2e88
# ╠═ffc866b1-688f-4b82-b547-54558348267c
# ╠═5c3d1bc1-23c6-488c-a04f-fdc676fe97de
# ╠═44dfebc1-5dab-408c-aca1-31236b047026
# ╠═3071932c-3d5e-40d9-bb49-ac24f7bc71b9
# ╠═3bf38f07-da8e-4429-bcc0-612ec5f6ddb9
# ╠═f60bd07a-85ad-4936-a8d5-bbebc5eae248
# ╠═c49b9e67-aba8-4ab9-8f9e-d20bbc9ca1b3
# ╠═b444d59e-ded5-416f-92db-081659c34a67
# ╠═3a9fb962-1bbb-4a11-8010-0274c0e4603a
# ╠═44bfa42b-95eb-4b52-b614-2f407428e456
# ╠═743b8553-6943-4e36-b969-b1bf5b160714
# ╠═8b6fb851-2b70-4b06-9dbd-dbcb608ab76a
# ╠═8d82c6c8-1e3b-4bdd-a07a-5efd62f83e14
# ╠═18ce520b-bbd9-4870-a396-adf139d8ab72
# ╠═50a17efc-4c91-497f-a328-0aa352b5c1d0
# ╠═22012d47-9a83-4ad6-8ab6-866489f36026
# ╠═55e5292c-016a-42e4-b9f6-1f0236fb3854
# ╠═74721157-70de-4e54-aaa2-8fbf409096e9
# ╠═c300c725-74ea-453b-98c3-08867cffcb94
# ╠═c295166e-b0f2-4ee4-8f8d-86f765e00c6a
# ╠═c09d1d8e-feaa-42f7-966e-20d8e160545b
# ╠═3668abc8-c4f9-4741-b591-d9490956a92f
# ╠═3308997a-6176-4db7-8dd8-d9c253197e90
# ╠═49b842d9-05c4-4bd7-a924-8b4c31faa618
# ╠═b5d2b8a1-bbe5-421b-96d3-e1e7a2c94326
# ╠═1f585d28-81cc-44fe-bf68-ded4ec427636
# ╠═4333c797-f26a-40bc-9857-8290438b3613
# ╠═eed02bd4-5d44-4604-879a-44411d79a76d
# ╠═94cc5583-2bc4-454d-9a90-123f9a9683b2
# ╠═dcce9b04-d7e0-4041-aa92-57964f69d4b2
# ╠═35180e55-dbc9-4961-8af1-b808a00a3950
# ╠═d90e9f30-0907-486e-b814-a0c47420c813
# ╠═4822cd69-1b8c-447c-a7b3-63985a9ade58
# ╠═5a3b743d-065f-45b1-ba40-b8ece8693fce
# ╠═6f2d98a0-9620-4eac-ab33-4465a73857a9
# ╠═f8b59e35-0bd5-4f2b-b7eb-93e80dc94187
