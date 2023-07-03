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

# ╔═╡ d331f88c-142b-11ee-06b5-530f1ac7d53a
using PlutoUI, HypertextLiteral

# ╔═╡ 9c5f0f57-bb88-4646-b01f-4f72588a7590
TableOfContents(title="📚 Table of Contents", aside=true)

# ╔═╡ fadf08b2-7b13-4dd9-b5d5-2c1f5bc10f3d
md"""
# Binary-rational numbers between $a_{10}, b_{10}$, where $a_{10}, b_{10} \in (0,1)$ 
"""

# ╔═╡ 3d7e29db-9c07-4bb2-abe6-dc2fea35c907
md"""
## Description of the problem
"""

# ╔═╡ aebeae2f-ff79-4814-a296-adbfa8b4cfa7
md"""
The program will ask for $2$ numbers $a_{10},b_{10}(a_{10} < b_{10})   \in (0,1)$ and will print all the numbers in $[a,b]$ which have a finite binary representation (are rationals in the binary system) with a a given number of '$digits$' in the fractional part.
"""

# ╔═╡ 355627d0-d84f-465e-8d85-ea5b5be28e63
md"""
## The main idea
"""

# ╔═╡ 629af3c1-551a-4eca-816b-f0bb5bfec479
md"""
Having selected the maximum number digits of the fractional part, called '$digits$', the main idea revolves around:
1. Converting the $2$ given numbers, $a$ and $b$, to binary such that $a < b$.
2. Starting from $a$ and adding $2^{-digits}$ till we get to $b$.
 By doing this, we will have all the rational binary numbers between $a$ and $b$ with maximum number of digits $b$.
3. We will convert every single one of the numbers we get from step "2." to decimal to arrive to the wanted result.
"""

# ╔═╡ 8ef960fd-9f15-4b0e-b763-0fe59cebef8d
md"""
### Possible problems & proposed fixes
"""

# ╔═╡ f1e0f4db-3d72-4b58-add5-e05bb1217d13
md"""
 - If the smaller number, '$a$',  was truncated, we are dealing with a smaller number, so we will start our process from the next one (by adding $2^{-digits}$ to $a$).
- If the bigger number, '$b$',  was truncated, that means $b$ is not binary-rational with at most $digits$ digits in its fractional part, so we don't lose any binary-rational if we start from the truncated result.
- We will manually simulate the addition of $2^{-digits}$ to a as many times as we need to get from $a$ to $b$. So if  $a$'s binary expression is finite with less that $digits$ digits in its fractional part, we will fill $a$ with zeroes, making its fractional part $digits$ digits long.
"""

# ╔═╡ 236f2a47-ad7a-48d0-926c-4176a389bdb2
md"""
## Description of functions used 
"""

# ╔═╡ daccf69b-a3a4-445b-a78e-2e673dfe9d42
md"""
### Function: dec\_to\_binary\_fractional(fractional\_part, digit\_accur)
"""

# ╔═╡ 7e0c54ec-153a-4350-9518-b544c1c7cb71
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>inputs</u> 
	<ul>
  		<li>The fractional part of a decimal number,</li>
 	 	<li>A natural number which represents the digits of the fractional part of the binary representation of the inputed number.</li>
	</ul> 
	and <u>returns</u>  a string with the fractional part of the binary representation
		</p>""")

# ╔═╡ ce9796b8-e9af-4672-bbad-a05d0da4843b

function dec_to_binary_fractional(fractional_part, digit_accur)
#Initialization	
	fractional_string = "" #holds digits of fractional part of the number
	flag = 0  #0 used to check truncation cases
##############	
	while length(fractional_string) < digit_accur && fractional_part!=0 
		mult = fractional_part*2 #only used for our ease
		fractional_string *= string(floor(Int, mult))
		fractional_part = mult-floor(mult)
	end
	if fractional_part !=0
		flag=1 # the number has been truncated
	end
	
	return fractional_string, flag
end

# ╔═╡ 39c76e57-95fb-4686-ad99-4b13c8ebf57b
md"""
### Function: fill\_with\_zero(fractional\_string, n)
"""

# ╔═╡ 0551b754-ce4b-47e9-8241-0a1da05d4156
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>input:</u> 
	<ul>
  		<li>A string with the fractional part of a binary numbers, <i> fractional_string</i>, </li>
		<li>A natural number, <i> n</i>, which indicates the desired length of the final fractional part, when we add zeroes to its right. </li>
	</ul> 

Its self-explanatory-it adds as many zeroes as the fractional part needs to be of length <i>n</i> and then <u>returns</u> the result.
		</p>""")

# ╔═╡ 93e0004c-83c4-44e7-b4b5-473ca5de3184
function fill_with_zero(fractional_string, n)
    if length(fractional_string) < n
        diff = n - length(fractional_string)
        for i in 1:diff
            fractional_string *= '0' #fill with zeroeeees
        end
    end
    return fractional_string
end

# ╔═╡ 69e8b6ff-1b42-467b-84ed-69fa9aa4ea9c
md"""
### Function: fixing\_truncation\_problems(fractional\_a, flag\_a, fractional\_b, flag\_b) 
"""

# ╔═╡ bac85a57-a2e9-4e7c-b016-992407cbe3f0
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>inputs</u> 
	<ul>
  		<li>Two string with the fractional parts of 2 binary numbers, <i> fractional_a, fractional_b</i>, </li>
 	 	<li> Two variables that indicate if the 2 inputed fractional representations have been truncated, <i> flag_a, flag_b</i>. </li>
	</ul> 

The function returns the 2 numbers <i>starting, ending</i> that are the bounds of our search for binary rationals ∈(a,b). <br>

In our context, its used to
<ul> 
	<li>Determine if we need to start checking for binary rational numbers after <i>a</i> (if <i>a</i> was truncated), </li> 
	<li> Fill <i>a,b</i> with zeroes to be able to simulate binary addition manually, as it will be described below. </li>
</ul> 
		</p>""")

# ╔═╡ b91d1a99-1b85-48b7-b8ea-f808cf53820e
md"""
### Function: give\_next(fractional\_string, digits) 
"""

# ╔═╡ 4c05d562-a1ee-4b02-a1b3-947b21c289dc
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>input:</u> 
	<ul>
  		<li>A string with the fractional part of a binary numbers, <i> fractional_string</i>, </li>
	</ul> 

Its goal is to manually simulate the addition of "<i>One</i>"(defined below) to the fractional string which is inputed <br>

"<i>One</i>": The smallest binary number with length equal to fractional_string's length (0.0...01 with  length(fractional_string)-1 zeroes). <br>
</p>
<p>
Finally, the function returns a string with the fractional part of result of the addition mentioned above
		</p>""")

# ╔═╡ dff11885-b564-41c9-83e2-23b3afdacfdf
function give_next(fractional_string) 
#Initialization 
	digits = length(fractional_string)
    one = ""  #the smallest number ("the one") with 'digits' number of digits in its fractional part
	for i in 1:digits-1
        one *= "0"
    end
    one *= "1" #one = 00...01 n-1 zeroes
    if length(fractional_string) < digits
        fractional_string = fill_with_zeroes(fractional_string, digits)
	end
 	carry_over = 0 # carry over from bitwise addition
    next_number = "" #wanted number	
#Main process
    for i in digits:-1:1
        bitwise_sum = parse(Int64,fractional_string[i]) + parse(Int64,one[i]) + carry_over
        if bitwise_sum == 1 || bitwise_sum == 0 
            next_number *= string(bitwise_sum) 
            carry_over = 0
        elseif bitwise_sum ==2
            next_number *= string(0)
            carry_over = 1
		elseif bitwise_sum ==3	
			next_number *= string(1)
            carry_over = 1
        end
    end
    #The addition started from right to left, so we need to reverse 
    next_number =  reverse(next_number) # next = "0." * klasm_next
    return next_number
end

# ╔═╡ 99ed6258-8ef3-4578-bbe7-299aeef8dcf2
md"""
### Function: binary\_to\_decimal(fractional\_string)
"""

# ╔═╡ e29d18b3-ee21-41e5-b762-efa16fd0caf7
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>input:</u> 
	<ul>
  		<li>A string with the fractional part of a binary numbers, <i> fractional_string</i>. </li>
	</ul> 

It <u>returns</u> the decimal expression of the binary number with fractional matching the input.
		</p>""")

# ╔═╡ 89e6483f-e557-4bf1-88cc-44bcd777a1f2
function binary_to_decimal(fractional_string)
    mysum = 0
    for i in 1:length(fractional_string)
        d_i = parse(Int64, fractional_string[i])
        mysum  += d_i /(2^i)
    end
    return string(mysum)
end

# ╔═╡ 88a9fa86-3fdc-4b08-b9dd-f1ad34beda64
md"""
### Function: main(a, b, digits)  (optional function)
"""

# ╔═╡ ace7cc1b-8f7d-413f-90bc-6c265fee6f11
Show(MIME"text/html"(),"""<p style="font-size:13.0pt">
		The function below takes as <u>input:</u> 
	<ul>
  		<li>Two decimal numbers ∈(0,1), <i>a, b</i>  </li>
		<li>A natural number, <i>digits</i>, which indicates the maximum length of the fractional part of the desired binary rationals</li>
	</ul> 

It <u>prints</u> the desired binary rationals.
		</p>""")

# ╔═╡ 980e70ab-f148-4ac9-8d9e-18b14de17069
ShowMe(text="Show Me!!! 🤠") = @htl("""
<span>
<button  style="font-size:16px;
width:150px;
	padding:10px; 
	text-align: center;
	border-radius:10px;
	background-color:rgb(6,41,88);;
	color:white;
  	border:none;
	margin: 0 35% ;
"

>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let count = 1

	button.addEventListener("click", (e) => {
		count += 1

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.value = count
		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	span.value = count

</script>
</span>
""")

# ╔═╡ ad1e7a2e-957a-4f3f-b1b6-cc989a58cd7c
macro seeprints(expr)
	quote
		stdout_bk = stdout
		rd, wr = redirect_stdout()
		$expr
		redirect_stdout(stdout_bk)
		close(wr)
		read(rd, String) |> Text
	end
end


# ╔═╡ 6d0574ba-88ea-4e17-afe9-205c0a968ab1
md"""
## Problem in action
"""

# ╔═╡ 2735ff2d-3f53-465f-adde-993ed2a82a1c
md"""
### Selection of bounds & maximum length
"""

# ╔═╡ 399d5d55-5429-4367-8ff7-014a159fb298
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Pick the first number:
		</p>""")

# ╔═╡ 75cc1e07-6129-4d4d-b3a2-ebd70e482992
@bind first_number html"""<input value="0.25" "type="number" min="0" max="1" step="0.01"  style="border: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 53d58d7a-1880-4a0c-87fe-6785e6fc19e5
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Now pick the second number:
		</p>""")

# ╔═╡ 99132992-de52-4855-82dd-7e94b748da56
@bind second_number html"""<input value="0.45" "type="number" min="0" max="1" step="0.01"  style="border: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 16740ec3-4f87-42ce-a8fc-d3938763e59e
Show(MIME"text/html"(),"""<p style="font-size:14.0pt">
		In this step, you can either use the <i>function</i> "main" and get the desired result (by enabling the following cell), or you can <b>follow through</b> and see the 🪄 of the reactive Pluto Noteboooks!
		</p>""")


# ╔═╡ c97cf58f-efbe-4873-a831-b1a348132c60
md"""
### Main action
"""

# ╔═╡ 4807aae6-47d1-42a5-adbc-6ecc384da91e
begin #we want a<b
	if (parse(Float64, first_number) > parse(Float64, second_number) )
		b = parse(Float64, first_number);
		a = parse(Float64, second_number);
	else	
		a = parse(Float64, first_number);
		b = parse(Float64, second_number);
		
	end	
	Show(MIME"text/html"(),"""<p style="font-size:18.0pt">
		Let the 🪄 name 'a' the smaller of the two and 'b' the bigger number!
		</p>""")
end

# ╔═╡ 2b545234-70e5-4bb6-9845-548033d973eb
Show(MIME"text/html"(),"""<p style="font-size:15.0pt">
		<i>Select below the maximum length of the fractional part of the binary rationals we are searching for(Less than 24):</i>
		</p>""")

# ╔═╡ b02ce87e-2585-4d91-b8a0-835b2b68c169
@bind digits Slider(3:24, 8, true)

# ╔═╡ 9fddc502-590d-4aa8-a614-351ee5793942
function fixing_truncation_problems(fractional_a, flag_a, fractional_b, flag_b)
	if flag_a == 1 #truncated -> dealing with number < a. So I'll start from next so as to get binary rationals  ∈(a,b) .
	    starting = give_next(fractional_a)
	else # a not truncated
        starting = fill_with_zero(fractional_a, digits)
    end
	if  flag_b == 1 #b  truncated -> We are OK with that!
		ending = fractional_b
	else #b not truncated
		ending = fill_with_zero(fractional_b)
    end
	return(starting, ending)
end	

# ╔═╡ a5e82c79-15aa-42cb-990c-2c4c9638bdb6
function main(a, b, digits)
######################	
###
## Conversion to binary
#	
	fractional_a, flag_a = dec_to_binary_fractional(a, digits) #[0.101010, 0 or 1]
	fractional_b, flag_b = dec_to_binary_fractional(b, digits) #[0.101010, 0 or 1]
######################
###
## Fixing trunaction problems	
#
	starting, ending = fixing_truncation_problems(fractional_a, flag_a, fractional_b, flag_b)
######################
###
## Let's find binary rationals :D
#	
	counter = 0 #let's also count 'em :]
	upper_limit = give_next(ending) # we don't allow numbers > upper_limit
    while starting != upper_limit
        counter += 1
        starting_dec = binary_to_decimal(starting)
        println("0." * starting, " ---> ", starting_dec)
        starting = give_next(starting) 
    end
    # last printing
    ending_dec, ending_flag = bin2dec(ending)
    println("0." * ending, "--->:", ending_dec)
    #
######################
###
## Output data
#	
	if counter == 0
		println("\n The were no binary rationals ∈($a,$b) with at most $digits digits in their fractional part.")
	elseif counter > 1
   		println("\n All binary rational numbers ∈($a,$b) with at most $digits digits in their fractional part were $counter.")
	end	
######################       
end

# ╔═╡ 400e66dd-abba-4df2-af48-4f84b5ab5246
# ╠═╡ disabled = true
#=╠═╡
main(first_number, second_number, digits)

  ╠═╡ =#

# ╔═╡ f260d6a2-667a-4cb4-ad38-7df1ec7dd956
begin
fractional_a, flag_a = dec_to_binary_fractional(a, digits)
###### Number a	
	if flag_a == 1		
		Show(MIME"text/html"(),"""<ul> 
		<li style="font-size:16.0pt"> 
			Fractional part of a=$a: $fractional_a (<span style="color:red;">truncated</span>)
		</li>
		</ul>""")
	else
		Show(MIME"text/html"(),"""
		<ul> 
		<li style="font-size:16.0pt"> 
		Fractional part of a=$a: $fractional_a (<span style="color:green;">not truncated</span>)
		</li></ul>""")
		
	end
end

# ╔═╡ 90c42944-406c-4316-8542-8729774107c5
begin
###### Number b
fractional_b, flag_b = dec_to_binary_fractional(b, digits)
	if flag_b ==1
		Show(MIME"text/html"(),"""<ul> 
			<li style="font-size:16.0pt"> 
			Fractional part of b=$b: $fractional_b (<span style="color:red;">truncated</span>)
		</li>
		</ul>""")
	else
		Show(MIME"text/html"(),"""<ul> 
		<li style="font-size:16.0pt"> 
			Fractional part of b=$b: $fractional_b (<span style="color:green;">truncated</span>)
		</li>
		</ul>""")
	end
end	

# ╔═╡ d24f37e8-28fa-4dac-b914-46d603e35288
Show(MIME"text/html"(),"""<p style="font-size:18.0pt">
		💡 <i>What will happen if i move the slider of max-length to the 👉👉?</i>
		</p>""")


# ╔═╡ 474ef423-46ce-45b5-ab7d-b2e69e1eae62
begin
starting, ending = fixing_truncation_problems(fractional_a, flag_a, fractional_b, flag_b)
	starting_dec = binary_to_decimal(starting)
	ending_dec = binary_to_decimal(ending)
		Show(MIME"text/html"(),"""
		<h6 style="font-size:16.0pt">So the starting and the ending numbers are: </h6> <br>
		<p  style="font-size:14.0pt">
		Starting number in </i>decimal</i> $starting_dec  (a<sub>(10)</sub>=$a)  <br>
		Starting number in </i>binary</i> : $starting   (a<sub>(2)</sub>= $fractional_a ) <br>
		Ending number in </i>decimal</i>  : $ending_dec    (b<sub>(10)</sub>=$b)  <br>
		Ending number in </i>binary</i>   : $ending (b<sub>(2)</sub>= $fractional_b ) 
		</p>""")
end

# ╔═╡ 395a8b53-b616-44ca-aa33-bb2880c2eac9
md"""
### Let's find binary rationals and count 'em😋
"""

# ╔═╡ d3c0f3b5-0de6-4bc5-a364-1389c32d28d5
begin
#Main process
	counter = 0 #let's also count 'em :]
	rationals_matrix = [] #initliazation
	upper_limit = give_next(ending) # we don't allow numbers > b
	while starting != upper_limit
		counter += 1
		starting_dec = binary_to_decimal(starting)
		push!(rationals_matrix, [starting, starting_dec])
		starting = give_next(starting) 
	end

	if counter == 0 
		Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There were <u>no</u> binary rationals ∈($a, $b) with at most $digits digits on their binary fractional part.</p>""")
	elseif counter == 1	
		
 Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There was only 1 binary rational ∈($a,$b) with at most $digits digits in its fractional part. <br> Do you want to see it? </hp>""")
    else	
		Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There were <span style="font-size:25px; font-weight:500;">$counter</span> binary rational ∈($a,$b) with at most $digits digits in their fractional part. <br>
		</p>""")

	end
end

# ╔═╡ fac4d8e2-ed32-437e-97c4-ed598a047b30
@bind num_clicks ShowMe()

# ╔═╡ 35675a32-1d96-4d43-be2f-ae9db3dfae1b
begin
	if mod(num_clicks,2) == 1
		@seeprints for j=1:counter
			if j==1
				println(repeat(" ", floor(Int,digits/2)-1), "Binary", repeat(" ", floor(Int,digits)),    "Decimal \n ")
			end	
			println("0." * rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
		end
		#println("0." * ending, " ---> ", ending_dec)
	end
end	

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.51"
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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

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

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═d331f88c-142b-11ee-06b5-530f1ac7d53a
# ╠═9c5f0f57-bb88-4646-b01f-4f72588a7590
# ╠═fadf08b2-7b13-4dd9-b5d5-2c1f5bc10f3d
# ╟─3d7e29db-9c07-4bb2-abe6-dc2fea35c907
# ╟─aebeae2f-ff79-4814-a296-adbfa8b4cfa7
# ╟─355627d0-d84f-465e-8d85-ea5b5be28e63
# ╟─629af3c1-551a-4eca-816b-f0bb5bfec479
# ╟─8ef960fd-9f15-4b0e-b763-0fe59cebef8d
# ╟─f1e0f4db-3d72-4b58-add5-e05bb1217d13
# ╟─236f2a47-ad7a-48d0-926c-4176a389bdb2
# ╟─daccf69b-a3a4-445b-a78e-2e673dfe9d42
# ╟─7e0c54ec-153a-4350-9518-b544c1c7cb71
# ╠═ce9796b8-e9af-4672-bbad-a05d0da4843b
# ╟─39c76e57-95fb-4686-ad99-4b13c8ebf57b
# ╟─0551b754-ce4b-47e9-8241-0a1da05d4156
# ╠═93e0004c-83c4-44e7-b4b5-473ca5de3184
# ╟─69e8b6ff-1b42-467b-84ed-69fa9aa4ea9c
# ╟─bac85a57-a2e9-4e7c-b016-992407cbe3f0
# ╟─9fddc502-590d-4aa8-a614-351ee5793942
# ╟─b91d1a99-1b85-48b7-b8ea-f808cf53820e
# ╟─4c05d562-a1ee-4b02-a1b3-947b21c289dc
# ╟─dff11885-b564-41c9-83e2-23b3afdacfdf
# ╟─99ed6258-8ef3-4578-bbe7-299aeef8dcf2
# ╟─e29d18b3-ee21-41e5-b762-efa16fd0caf7
# ╠═89e6483f-e557-4bf1-88cc-44bcd777a1f2
# ╟─88a9fa86-3fdc-4b08-b9dd-f1ad34beda64
# ╟─ace7cc1b-8f7d-413f-90bc-6c265fee6f11
# ╠═a5e82c79-15aa-42cb-990c-2c4c9638bdb6
# ╠═980e70ab-f148-4ac9-8d9e-18b14de17069
# ╟─ad1e7a2e-957a-4f3f-b1b6-cc989a58cd7c
# ╟─6d0574ba-88ea-4e17-afe9-205c0a968ab1
# ╟─2735ff2d-3f53-465f-adde-993ed2a82a1c
# ╟─399d5d55-5429-4367-8ff7-014a159fb298
# ╟─75cc1e07-6129-4d4d-b3a2-ebd70e482992
# ╟─53d58d7a-1880-4a0c-87fe-6785e6fc19e5
# ╟─99132992-de52-4855-82dd-7e94b748da56
# ╠═400e66dd-abba-4df2-af48-4f84b5ab5246
# ╟─16740ec3-4f87-42ce-a8fc-d3938763e59e
# ╟─c97cf58f-efbe-4873-a831-b1a348132c60
# ╟─4807aae6-47d1-42a5-adbc-6ecc384da91e
# ╟─f260d6a2-667a-4cb4-ad38-7df1ec7dd956
# ╟─90c42944-406c-4316-8542-8729774107c5
# ╟─2b545234-70e5-4bb6-9845-548033d973eb
# ╟─b02ce87e-2585-4d91-b8a0-835b2b68c169
# ╟─d24f37e8-28fa-4dac-b914-46d603e35288
# ╟─474ef423-46ce-45b5-ab7d-b2e69e1eae62
# ╟─395a8b53-b616-44ca-aa33-bb2880c2eac9
# ╟─d3c0f3b5-0de6-4bc5-a364-1389c32d28d5
# ╟─fac4d8e2-ed32-437e-97c4-ed598a047b30
# ╟─35675a32-1d96-4d43-be2f-ae9db3dfae1b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
